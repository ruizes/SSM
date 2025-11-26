package endorphin.domain;

import java.sql.Timestamp;
import java.util.List;

/**
 * Reply 回复实体类
 *
 * @author igaozp
 * @version 1.0
 * @since 2016
 */
public class Reply {
    /**
     * 文章回复属性
     */
    private int replyId;
    private int replyPostId;
    private int replyParentId;
    private String replyUserName;
    private String replyContent;
    private int replyGoodCount;
    private int replyBadCount;
    private Timestamp replyCreateTime;
    private List<Reply> childReplies;

    public int getReplyId() {
        return replyId;
    }

    public void setReplyId(int replyId) {
        this.replyId = replyId;
    }

    public int getReplyPostId() {
        return replyPostId;
    }

    public void setReplyPostId(int replyPostId) {
        this.replyPostId = replyPostId;
    }

    public int getReplyParentId() {
        return replyParentId;
    }

    public void setReplyParentId(int replyParentId) {
        this.replyParentId = replyParentId;
    }

    public List<Reply> getChildReplies() {
        return childReplies;
    }

    public void setChildReplies(List<Reply> childReplies) {
        this.childReplies = childReplies;
    }

    public String getReplyUserName() {
        return replyUserName;
    }

    public void setReplyUserName(String replyUserName) {
        this.replyUserName = replyUserName;
    }

    public String getReplyContent() {
        return replyContent;
    }

    public void setReplyContent(String replyContent) {
        this.replyContent = replyContent;
    }

    public int getReplyGoodCount() {
        return replyGoodCount;
    }

    public void setReplyGoodCount(int replyGoodCount) {
        this.replyGoodCount = replyGoodCount;
    }

    public int getReplyBadCount() {
        return replyBadCount;
    }

    public void setReplyBadCount(int replyBadCount) {
        this.replyBadCount = replyBadCount;
    }

    public Timestamp getReplyCreateTime() {
        return replyCreateTime;
    }

    public void setReplyCreateTime(Timestamp replyCreateTime) {
        this.replyCreateTime = replyCreateTime;
    }

    @Override
    public String toString() {
        return "Reply {" +
                "replyId = " + replyId +
                ", replyPostId = " + replyPostId +
                ", replyParentId = " + replyParentId +
                ", replyUserName = " + replyUserName +
                ", replyContent = " + replyContent +
                ", replyGoodCount = " + replyGoodCount +
                ", replyBadCount = " + replyBadCount +
                ", replyCreateTime = " + replyCreateTime + "}";
    }
}
