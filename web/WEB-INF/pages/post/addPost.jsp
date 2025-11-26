<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>添加新主题</title>
    <link rel="stylesheet" href="../../resources/css/material-icons.css">
    <link rel="stylesheet" href="../../resources/css/material.min.css">
    <script type="text/javascript" src="../../resources/js/material.min.js"></script>
    <script type="text/javascript" src="../../resources/js/jquery-3.1.1.min.js"></script>
    <style>
        .center {
            margin-left: auto;
            margin-right: auto;
        }
        .card-width {
            min-width: 500px;
        }
        .draft-status {
            font-size: 12px;
            color: #666;
            margin-top: 10px;
            text-align: center;
        }
        .draft-status.success {
            color: #4CAF50;
        }
        .draft-status.error {
            color: #F44336;
        }
    </style>
</head>
<body>
<!-- Uses a header that scrolls with the text, rather than staying
  locked at the top -->
<div class="mdl-layout mdl-js-layout">
    <header class="mdl-layout__header mdl-layout__header--scroll mdl-color--grey-50">
        <div class="mdl-layout__header-row">
            <!-- Title -->
            <a class="mdl-layout-title mdl-navigation__link mdl-color-text--pink-400"
               href="/board/listPosts-<%=request.getParameter("boardId")%>">Excited</a>
            <!-- Add spacer, to align navigation to the right -->
            <div class="mdl-layout-spacer"></div>
            <!-- Navigation -->
            <nav class="mdl-navigation">
                <c:choose>
                    <c:when test="${username != null}">
                        <a class="mdl-navigation__link mdl-color-text--pink-400" href="/user/listUserInfo?username=${username}">${username}</a>
                        <a class="mdl-navigation__link mdl-color-text--black" href="/user/loginOut">注销</a>
                    </c:when>
                    <c:when test="${username == null}">
                        <a class="mdl-navigation__link mdl-color-text--pink-400" href="/userLogin">登录</a>
                        <a class="mdl-navigation__link mdl-color-text--pink-400" href="/userRegister">注册</a>
                    </c:when>
                </c:choose>
            </nav>
        </div>
    </header>
    <main class="mdl-layout__content">
        <div class="page-content">
            <!-- Your content goes here -->
            <div class="mdl-grid">
                <div class="mdl-cell--4-col"></div>
                <div class="mdl-cell--4-col">
                    <div class="mdl-card mdl-shadow--2dp center card-width">
                        <div class="mdl-card__title">
                            <h4 class="mdl-color-text--pink-400">添加新主题</h4>
                        </div>
                        <div class="mdl-card__subtitle-text">
                            <form name="form" action="/post/addPost" method="post">
                                <table class="mdl-data-table mdl-js-data-table mdl-data-table--selectable center card-width">
                                    <tr>
                                        <td>板块ID:</td>
                                        <td>
                                            <div class="mdl-textfield mdl-js-textfield">
                                                <input class="mdl-textfield__input" name="postBoardId" id="postBoardId"
                                                       readonly value="<%=request.getParameter("boardId")%>"/>
                                                <label class="mdl-textfield__label" for="postBoardId"></label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>用户名:</td>
                                        <td>
                                            <div class="mdl-textfield mdl-js-textfield">
                                                <input class="mdl-textfield__input" name="postUserName" id="postUserName"
                                                       readonly value="<%=request.getParameter("userName")%>"/>
                                                <label class="mdl-textfield__label" for="postUserName"></label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>文章名称:</td>
                                        <td>
                                            <div class="mdl-textfield mdl-js-textfield">
                                                <input class="mdl-textfield__input" type="text" name="postTitle"
                                                       id="postTitle">
                                                <label class="mdl-textfield__label" for="postTitle"></label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>文章内容:</td>
                                        <td>
                                            <div class="mdl-textfield mdl-js-textfield">
                                                <textarea class="mdl-textfield__input" type="text" name="postContent" rows="5" maxrows="5"
                                                          id="postContent"></textarea>
                                                <label class="mdl-textfield__label" for="postContent"></label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input class="mdl-button mdl-js-button mdl-button--raised mdl-color--pink-400 mdl-color-text--white" type="submit"
                                                   value="提交" name="submit" align="center"/>
                                        </td>
                                        <td>
                                            <a href="/board/listPosts-${boardId}" class="mdl-button mdl-js-button mdl-button--raised">返回</a>
                                        </td>
                                    </tr>
                                </table>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="mdl-cell--4-col"></div>
            </div>
        </div>
    </main>
</div>

<script type="text/javascript">
    // 草稿保存间隔时间（毫秒）
    var DRAFT_SAVE_INTERVAL = 30000; // 30秒
    // 定时器ID
    var draftTimer = null;
    // 最后保存时间
    var lastSaveTime = null;
    // 是否正在保存
    var isSaving = false;

    // 页面加载完成后执行
    $(document).ready(function() {
        // 加载草稿
        loadDraft();
        
        // 启动定时保存草稿
        startAutoSave();
        
        // 页面卸载前保存草稿
        $(window).on('beforeunload', function() {
            saveDraft();
        });
    });

    // 加载草稿
    function loadDraft() {
        var boardId = $('#postBoardId').val();
        var userName = $('#postUserName').val();
        
        if (!boardId || !userName) {
            return;
        }
        
        $.ajax({
            url: '/post/loadDraft',
            type: 'GET',
            data: {
                boardId: boardId,
                userName: userName
            },
            success: function(response) {
                if (response.success && response.draft) {
                    $('#postTitle').val(response.draft.postTitle);
                    $('#postContent').val(response.draft.postContent);
                    updateDraftStatus('草稿已加载', 'success');
                }
            },
            error: function() {
                updateDraftStatus('加载草稿失败', 'error');
            }
        });
    }

    // 保存草稿
    function saveDraft() {
        if (isSaving) {
            return;
        }
        
        var boardId = $('#postBoardId').val();
        var userName = $('#postUserName').val();
        var postTitle = $('#postTitle').val();
        var postContent = $('#postContent').val();
        
        // 如果没有输入内容，不保存草稿
        if (!boardId || !userName || (!postTitle && !postContent)) {
            return;
        }
        
        isSaving = true;
        
        $.ajax({
            url: '/post/saveDraft',
            type: 'POST',
            data: {
                postBoardId: boardId,
                postUserName: userName,
                postTitle: postTitle,
                postContent: postContent
            },
            success: function(response) {
                if (response.success) {
                    lastSaveTime = new Date();
                    updateDraftStatus('草稿已保存 (' + formatTime(lastSaveTime) + ')', 'success');
                } else {
                    updateDraftStatus('保存草稿失败: ' + response.message, 'error');
                }
            },
            error: function() {
                updateDraftStatus('保存草稿失败', 'error');
            },
            complete: function() {
                isSaving = false;
            }
        });
    }

    // 启动自动保存
    function startAutoSave() {
        if (draftTimer) {
            clearInterval(draftTimer);
        }
        
        draftTimer = setInterval(function() {
            saveDraft();
        }, DRAFT_SAVE_INTERVAL);
    }

    // 更新草稿状态显示
    function updateDraftStatus(message, type) {
        // 移除现有的状态元素
        $('.draft-status').remove();
        
        // 创建新的状态元素
        var statusElement = $('<div class="draft-status ' + type + '">' + message + '</div>');
        
        // 添加到页面中
        $('.mdl-card__subtitle-text').append(statusElement);
        
        // 3秒后自动隐藏成功状态
        if (type === 'success') {
            setTimeout(function() {
                statusElement.fadeOut();
            }, 3000);
        }
    }

    // 格式化时间
    function formatTime(date) {
        var hours = date.getHours();
        var minutes = date.getMinutes();
        var seconds = date.getSeconds();
        
        // 补零
        hours = hours < 10 ? '0' + hours : hours;
        minutes = minutes < 10 ? '0' + minutes : minutes;
        seconds = seconds < 10 ? '0' + seconds : seconds;
        
        return hours + ':' + minutes + ':' + seconds;
    }
</script>
</body>
</html>