package endorphin.dao;

import endorphin.domain.Reply;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * ReplyDao 提供关于回复的操作接口
 *
 * @author igaozp
 * @version 1.0
 * @since 2016
 */
@Repository
public interface ReplyDao {
    /**
     * 添加回复
     *
     * @param reply 需要添加的回复
     */
    void addReply(Reply reply);

    /**
     * 指定文章的回复
     *
     * @param postId 指定的文章 id
     * @return 回复列表
     */
    List<Reply> listReplyByPostId(int postId);

    /**
     * 删除回复
     *
     * @param postId 回复 id
     */
    void deleteReplyById(int postId);

    /**
     * 通过回复 id 查找回复
     *
     * @param replyId 回复 id
     * @return 查找到的回复
     */
    Reply findReplyByReplyId(int replyId);

    /**
     * 给回复点赞
     *
     * @param replyId 回复 id
     */
    void likeReply(int replyId);

    /**
     * 给回复点踩
     *
     * @param replyId 回复 id
     */
    void dislikeReply(int replyId);

    /**
     * 根据关键词搜索回复
     *
     * @param keyword 搜索关键词
     * @return 回复列表
     */
    List<Reply> searchRepliesByKeyword(String keyword);

    /**
     * 获取回复的子回复
     *
     * @param replyId 回复 id
     * @return 子回复列表
     */
    List<Reply> listChildRepliesByReplyId(int replyId);
}
