package endorphin.service;

import endorphin.domain.Reply;

import java.util.List;

/**
 * ReplyService 回复功能的服务接口
 *
 * @author igaozp
 * @version 1.0
 * @since 2016
 */
public interface ReplyService {
    /**
     * 添加回复
     *
     * @param reply 回复实例
     */
    void addReply(Reply reply);

    /**
     * 获取指定文章的回复
     *
     * @param postId 文章 id
     * @return 回复列表
     */
    List<Reply> listReplyByPostId(int postId);

    /**
     * 删除回复
     *
     * @param replyId 回复 id
     */
    void deleteReply(int replyId);

    /**
     * 更新回复点赞数
     *
     * @param replyId 回复 id
     * @param goodCount 点赞数
     */
    void updateReplyGoodCount(int replyId, int goodCount);

    /**
     * 搜索回复
     *
     * @param keyword 搜索关键词
     * @return 回复列表
     */
    List<Reply> searchReplies(String keyword);

    /**
     * 通过父回复id查找子回复
     *
     * @param parentId 父回复id
     * @return 子回复列表
     */
    List<Reply> listReplyByParentId(int parentId);
}
