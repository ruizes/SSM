package endorphin.controller;

import endorphin.domain.Reply;
import endorphin.service.ReplyService;
import endorphin.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

/**
 * ReplyController
 *
 * @author igaozp
 * @version 1.0
 * @since 2016
 */
@Controller
@RequestMapping(value = "/reply")
public class ReplyController {
    private final ReplyService replyService;
    private final UserService userService;

    @Autowired
    public ReplyController(ReplyService replyService, UserService userService) {
        this.replyService = replyService;
        this.userService = userService;
    }

    /**
     * 添加回复
     *
     * @param reply 新增的回复
     * @return 重定向页面
     */
    @RequestMapping(value = "addReply", method = RequestMethod.POST)
    public String addReply(Reply reply) {
        replyService.addReply(reply);
        return "redirect:/post/postContent-" + reply.getReplyPostId();
    }

    /**
     * 回复点赞
     *
     * @param replyId 回复ID
     * @param request 请求对象
     * @return 重定向页面
     */
    @RequestMapping(value = "likeReply", method = RequestMethod.POST)
    public String likeReply(int replyId, HttpServletRequest request) {
        replyService.likeReply(replyId);
        // 获取当前页面URL，点赞后返回原页面
        String referer = request.getHeader("Referer");
        return "redirect:" + referer;
    }

    /**
     * 获取子评论
     *
     * @param parentReplyId 父评论ID
     * @return 子评论列表
     */
    @RequestMapping(value = "getChildReplies", method = RequestMethod.GET)
    public String getChildReplies(int parentReplyId, HttpServletRequest request) {
        request.setAttribute("childReplies", replyService.getChildReplies(parentReplyId));
        return "reply/childReplies"; // 返回复评论部分视图
    }

    /**
     * 搜索回复
     *
     * @param keyword 搜索关键词
     * @param request 请求对象
     * @return 搜索结果页面
     */
    @RequestMapping(value = "searchReplies", method = RequestMethod.GET)
    public String searchReplies(String keyword, HttpServletRequest request) {
        request.setAttribute("replies", replyService.searchRepliesByKeyword(keyword));
        return "reply/searchResults"; // 返回回复搜索结果页面
    }
}
