package endorphin.controller;

import endorphin.domain.Post;
import endorphin.domain.Reply;
import endorphin.service.BoardService;
import endorphin.service.PostService;
import endorphin.service.ReplyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * PostController
 *
 * @author igaozp
 * @version 1.0
 * @since 2016
 */
@Controller
@RequestMapping(value = "/post")
public class PostController {
    private final PostService postService;
    private final BoardService boardService;
    private final ReplyService replyService;

    @Autowired
    public PostController(PostService postService, BoardService boardService, ReplyService replyService) {
        this.postService = postService;
        this.boardService = boardService;
        this.replyService = replyService;
    }

    /**
     * 添加帖子
     *
     * @param post 新增的文章
     * @return 返回页面
     */
    @RequestMapping(value = "/addPost")
    public String addPost(Post post) {
        if (post != null) {
            Post newPost = post;
            Timestamp createLoginTime = new Timestamp(System.currentTimeMillis());
            newPost.setPostCreateTime(createLoginTime);
            newPost.setPostUpdateTime(createLoginTime);

            postService.addPostByPost(newPost);
            boardService.updatePostNum(newPost.getPostBoardId());

            return "redirect:postContent-" + post.getPostId();
        }
        return "error";
    }

    /**
     * 查看帖子
     *
     * @param postId  帖子 id
     * @param request 请求
     * @return 返回页面
     */
    @RequestMapping(value = "postContent-{postId}")
    public String intoPost(@PathVariable int postId, HttpServletRequest request) {
        System.out.println(postId);
        Post post = postService.listPostContent(postId);
        List<Reply> replies = replyService.listReplyByPostId(postId);

        if (post == null) {
            return "/error";
        }
        // 帖子有回复则添加回复信息
        if (replies != null) {
            request.setAttribute("replies", replies);
        }

        request.setAttribute("post", post);
        return "post/postContent";
    }

    /**
     * 保存帖子草稿
     *
     * @param post    帖子对象
     * @param request 请求
     * @return 返回JSON结果
     */
    @RequestMapping(value = "/saveDraft")
    @ResponseBody
    public Map<String, Object> saveDraft(Post post, HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            post.setPostDraftUpdateTime(new Timestamp(System.currentTimeMillis()));
            postService.savePostDraft(post);
            result.put("success", true);
            result.put("message", "草稿保存成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "草稿保存失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 加载帖子草稿
     *
     * @param postId  帖子 id
     * @param request 请求
     * @return 返回JSON结果
     */
    @RequestMapping(value = "/loadDraft-{postId}")
    @ResponseBody
    public Map<String, Object> loadDraft(@PathVariable int postId, HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            Post post = postService.loadPostDraft(postId);
            if (post != null && post.getPostDraft() != null) {
                result.put("success", true);
                result.put("draft", post.getPostDraft());
            } else {
                result.put("success", false);
                result.put("message", "没有找到草稿");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "草稿加载失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 搜索帖子
     *
     * @param keyword 搜索关键词
     * @param request 请求
     * @return 返回搜索结果页面
     */
    @RequestMapping(value = "/search")
    public String searchPosts(String keyword, HttpServletRequest request) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return "redirect:/main";
        }
        List<Post> posts = postService.searchPostsByKeyword(keyword);
        request.setAttribute("posts", posts);
        request.setAttribute("keyword", keyword);
        return "post/searchResult";
    }
}
