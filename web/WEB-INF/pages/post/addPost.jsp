<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>添加新主题</title>
    <link rel="stylesheet" href="../../resources/css/material-icons.css">
    <link rel="stylesheet" href="../../resources/css/material.min.css">
    <script type="text/javascript" src="../../resources/js/material.min.js"></script>
    <script type="text/javascript" src="../../resources/js/jquery-3.1.1.min.js"></script>
    <script type="text/javascript">
        // 定时保存草稿的时间间隔（毫秒）
        const SAVE_INTERVAL = 30000; // 30秒
        let saveTimer = null;
        let lastSaveTime = 0;

        $(document).ready(function() {
            // 页面加载时自动加载草稿
            loadDraft();

            // 监听表单输入变化，启动定时保存
            $('#postTitle, #postContent').on('input', function() {
                restartSaveTimer();
            });

            // 表单提交时清除定时保存
            $('form').on('submit', function() {
                clearSaveTimer();
            });
        });

        // 重启定时保存计时器
        function restartSaveTimer() {
            clearSaveTimer();
            saveTimer = setTimeout(saveDraft, SAVE_INTERVAL);
        }

        // 清除定时保存计时器
        function clearSaveTimer() {
            if (saveTimer) {
                clearTimeout(saveTimer);
                saveTimer = null;
            }
        }

        // 保存草稿
        function saveDraft() {
            const postTitle = $('#postTitle').val().trim();
            const postContent = $('#postContent').val().trim();
            const postBoardId = $('#postBoardId').val();
            const postUserName = $('#postUserName').val();

            // 如果内容为空，不保存
            if (!postTitle && !postContent) {
                return;
            }

            // 避免频繁保存
            const now = Date.now();
            if (now - lastSaveTime < 5000) { // 5秒内只保存一次
                restartSaveTimer();
                return;
            }
            lastSaveTime = now;

            // 发送保存草稿请求
            $.ajax({
                url: '/post/saveDraft',
                type: 'POST',
                data: {
                    postBoardId: postBoardId,
                    postUserName: postUserName,
                    postTitle: postTitle,
                    postContent: postContent
                },
                success: function(response) {
                    if (response.success) {
                        updateSaveStatus('草稿已保存', 'success');
                    } else {
                        updateSaveStatus('草稿保存失败: ' + response.message, 'error');
                    }
                },
                error: function() {
                    updateSaveStatus('网络错误，草稿保存失败', 'error');
                },
                complete: function() {
                    // 保存完成后，继续定时保存
                    restartSaveTimer();
                }
            });
        }

        // 加载草稿
        function loadDraft() {
            const postBoardId = $('#postBoardId').val();
            const postUserName = $('#postUserName').val();

            // 发送加载草稿请求
            $.ajax({
                url: '/post/loadDraft',
                type: 'GET',
                data: {
                    postBoardId: postBoardId,
                    postUserName: postUserName
                },
                success: function(response) {
                    if (response.success && response.draft) {
                        const draft = response.draft;
                        $('#postTitle').val(draft.postTitle || '');
                        $('#postContent').val(draft.postContent || '');
                        if (draft.postTitle || draft.postContent) {
                            updateSaveStatus('已加载上次保存的草稿', 'success');
                        }
                    }
                },
                error: function() {
                    console.log('加载草稿失败');
                }
            });
        }

        // 更新保存状态显示
        function updateSaveStatus(message, type) {
            let statusElement = $('.save-status');
            if (!statusElement.length) {
                statusElement = $('<div class="save-status"></div>');
                $('.mdl-card__subtitle-text').append(statusElement);
            }
            statusElement.text(message).removeClass('success error').addClass(type);

            // 3秒后隐藏成功状态
            if (type === 'success') {
                setTimeout(function() {
                    statusElement.fadeOut();
                }, 3000);
            }
        }
    </script>
    <style>
        .center {
            margin-left: auto;
            margin-right: auto;
        }
        .card-width {
            min-width: 500px;
        }
        .save-status {
            font-size: 12px;
            color: #666;
            margin-top: 10px;
            text-align: center;
        }
        .save-status.success {
            color: #4CAF50;
        }
        .save-status.error {
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
</body>
</html>