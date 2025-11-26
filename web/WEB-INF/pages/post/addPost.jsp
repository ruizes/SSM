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
        // 定时保存草稿，每5分钟保存一次
        setInterval(saveDraft, 300000);
        
        function saveDraft() {
            var postId = $('#postId').val();
            var postTitle = $('#postTitle').val();
            var postContent = $('#postContent').val();
            var postBoardId = $('#postBoardId').val();
            var postUserName = $('#postUserName').val();
            
            // 如果帖子ID为空，说明是新帖子，先创建一个空帖子获取ID
            if (postId == '') {
                $.ajax({
                    url: '/post/addPost',
                    type: 'POST',
                    data: {
                        postBoardId: postBoardId,
                        postUserName: postUserName,
                        postTitle: postTitle,
                        postContent: postContent
                    },
                    success: function(data) {
                        // 从返回的URL中提取帖子ID
                        var postId = data.split('-')[1];
                        $('#postId').val(postId);
                        // 保存草稿
                        saveDraftContent(postId, postTitle, postContent);
                    },
                    error: function() {
                        alert('创建帖子失败');
                    }
                });
            } else {
                // 保存草稿
                saveDraftContent(postId, postTitle, postContent);
            }
        }
        
        function saveDraftContent(postId, postTitle, postContent) {
            $.ajax({
                url: '/post/saveDraft',
                type: 'POST',
                data: {
                    postId: postId,
                    postTitle: postTitle,
                    postContent: postContent,
                    postDraft: postContent
                },
                success: function(data) {
                    if (data == 'success') {
                        console.log('草稿保存成功');
                    } else {
                        console.log('草稿保存失败');
                    }
                },
                error: function() {
                    console.log('草稿保存失败');
                }
            });
        }
        
        // 页面加载时加载草稿
        $(document).ready(function() {
            var postId = $('#postId').val();
            if (postId != '') {
                $.ajax({
                    url: '/post/loadDraft-' + postId,
                    type: 'GET',
                    success: function(data) {
                        // 从返回的页面中提取草稿内容
                        var draft = $(data).find('#postContent').val();
                        $('#postContent').val(draft);
                    },
                    error: function() {
                        console.log('加载草稿失败');
                    }
                });
            }
        });
    </script>
    <style>
        .center {
            margin-left: auto;
            margin-right: auto;
        }
        .card-width {
            min-width: 500px;
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
                                    <tr style="display: none;">
                                        <td>帖子ID:</td>
                                        <td>
                                            <div class="mdl-textfield mdl-js-textfield">
                                                <input class="mdl-textfield__input" name="postId" id="postId"
                                                       value="<%=request.getParameter("postId") != null ? request.getParameter("postId") : ""%>"/>
                                                <label class="mdl-textfield__label" for="postId"></label>
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