package endorphin.controller;

import endorphin.domain.Reply;
import endorphin.dao.ReplyDao;
import endorphin.service.ReplyService;
import endorphin.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
    private final ReplyDao replyDao;

    @Autowired
    public ReplyController(ReplyService replyService, UserService userService, ReplyDao replyDao) {
        this.replyService = replyService;
        this.userService = userService;
        this.replyDao = replyDao;
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
     * 给回复点赞
     *
     * @param replyId 回复 id
     * @param request 请求
     * @return 返回JSON结果
     */
    @RequestMapping(value = "/like-{replyId}")
    @ResponseBody
    public Map<String, Object> likeReply(@PathVariable int replyId, HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            replyService.likeReply(replyId);
            Reply reply = replyDao.findReplyByReplyId(replyId);
            result.put("success", true);
            result.put("goodCount", reply.getReplyGoodCount());
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "点赞失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 给回复点踩
     *
     * @param replyId 回复 id
     * @param request 请求
     * @return 返回JSON结果
     */
    @RequestMapping(value = "/dislike-{replyId}")
    @ResponseBody
    public Map<String, Object> dislikeReply(@PathVariable int replyId, HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        try {
            replyService.dislikeReply(replyId);
            Reply reply = replyDao.findReplyByReplyId(replyId);
            result.put("success", true);
            result.put("badCount", reply.getReplyBadCount());
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "点踩失败: " + e.getMessage());
        }
        return result;
    }

    /**
     * 搜索回复
     *
     * @param keyword 搜索关键词
     * @param request 请求
     * @return 返回搜索结果页面
     */
    @RequestMapping(value = "/search")
    public String searchReplies(String keyword, HttpServletRequest request) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return "redirect:/main";
        }
        List<Reply> replies = replyService.searchRepliesByKeyword(keyword);
        request.setAttribute("replies", replies);
        request.setAttribute("keyword", keyword);
        return "reply/searchResult";
    }
}
