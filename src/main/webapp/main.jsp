<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>我的世界模组中心 - Modrinth风格</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        }
        
        :root {
            --bg-primary: #0f1117;
            --bg-secondary: #161b25;
            --bg-card: #1c2330;
            --bg-hover: #2a3343;
            --accent-primary: #3a86ff;
            --accent-secondary: #5e60ce;
            --accent-success: #00b894;
            --accent-danger: #ff4757;
            --text-primary: #e6e9f0;
            --text-secondary: #a0a8c0;
            --border-radius: 12px;
            --transition: all 0.25s ease;
        }
        
        body {
            background: var(--bg-primary);
            color: var(--text-primary);
            min-height: 100vh;
            padding: 20px;
            overflow-x: hidden;
            position: relative;
        }
        
        /* 视频背景 */
        .video-background {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: -2;
        }
        
        /* 渐变叠加层 */
        .overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle at 10% 20%, rgba(15, 31, 49, 0.8) 0%, rgba(10, 18, 30, 0.9) 90%);
            z-index: -1;
        }
        
        /* 粒子容器 */
        #particles-js {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
        }
        
        .container {
            max-width: 1000px;
            margin: 20px auto;
            background: rgba(22, 27, 37, 0.9);
            backdrop-filter: blur(10px);
            border-radius: var(--border-radius);
            padding: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.1);
            position: relative;
            z-index: 1;
        }
        
        /* 头部区域 */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .brand {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .logo {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, var(--accent-primary), var(--accent-secondary));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            font-weight: bold;
            color: white;
            animation: pulse 3s infinite;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .brand-text {
            font-size: 28px;
            font-weight: 700;
            background: linear-gradient(90deg, var(--accent-primary), #8a2be2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 2px 10px rgba(58, 134, 255, 0.3);
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
            background: rgba(58, 134, 255, 0.1);
            border-radius: var(--border-radius);
            padding: 10px 20px;
            border: 1px solid rgba(58, 134, 255, 0.2);
            transition: var(--transition);
        }
        
        .user-info:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(58, 134, 255, 0.2);
        }
        
        .user-info span {
            color: var(--text-secondary);
        }
        
        .user-info a {
            color: var(--accent-danger);
            text-decoration: none;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .user-info a:hover {
            color: #ff8888;
            text-decoration: underline;
        }
        
        /* 功能区域 */
        .section {
            margin-bottom: 35px;
            animation: fadeIn 0.8s ease-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .section-title {
            font-size: 22px;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--accent-primary);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .section-title i {
            color: var(--accent-primary);
            font-size: 24px;
        }
        
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }
        
        .card {
            background: var(--bg-card);
            border-radius: var(--border-radius);
            padding: 25px;
            transition: var(--transition);
            border: 1px solid rgba(255, 255, 255, 0.05);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
        }
        
        .card::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(45deg, var(--accent-primary), var(--accent-secondary));
            z-index: -1;
            opacity: 0;
            transition: opacity 0.5s ease;
        }
        
        .card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
        }
        
        .card:hover::before {
            opacity: 1;
        }
        
        .card-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--accent-primary);
        }
        
        .card-title i {
            font-size: 20px;
        }
        
        .card-desc {
            color: var(--text-secondary);
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 20px;
            min-height: 60px;
        }
        
        .card-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .card-btn {
            background: rgba(58, 134, 255, 0.15);
            color: var(--accent-primary);
            border: none;
            border-radius: 6px;
            padding: 8px 16px;
            font-size: 14px;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            position: relative;
            overflow: hidden;
            z-index: 1;
        }
        
        .card-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 0%;
            height: 100%;
            background: var(--accent-primary);
            transition: width 0.3s ease;
            z-index: -1;
        }
        
        .card-btn:hover {
            color: white;
        }
        
        .card-btn:hover::before {
            width: 100%;
        }
        
        .admin-btn {
            background: rgba(255, 71, 87, 0.15);
            color: var(--accent-danger);
        }
        
        .admin-btn::before {
            background: var(--accent-danger);
        }
        
        /* 消息提示 */
        .msg {
            color: var(--accent-danger);
            font-size: 16px;
            padding: 15px;
            background: rgba(255, 71, 87, 0.1);
            border-radius: var(--border-radius);
            border: 1px solid var(--accent-danger);
            margin: 30px 0;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: pulseWarning 2s infinite;
        }
        
        @keyframes pulseWarning {
            0% { box-shadow: 0 0 0 0 rgba(255, 71, 87, 0.4); }
            70% { box-shadow: 0 0 0 10px rgba(255, 71, 87, 0); }
            100% { box-shadow: 0 0 0 0 rgba(255, 71, 87, 0); }
        }
        
        /* 响应式设计 */
        @media (max-width: 900px) {
            .header {
                flex-direction: column;
                gap: 20px;
                text-align: center;
            }
            
            .user-info {
                justify-content: center;
            }
        }
        
        @media (max-width: 600px) {
            .card-grid {
                grid-template-columns: 1fr;
            }
            
            .card-actions {
                flex-direction: column;
            }
            
            .card-btn {
                width: 100%;
                justify-content: center;
            }
        }
        
        /* 控制面板 */
        .video-controls {
            position: fixed;
            bottom: 20px;
            right: 20px;
            display: flex;
            gap: 10px;
            z-index: 10;
        }
        
        .control-btn {
            background: rgba(22, 27, 37, 0.8);
            border: 1px solid var(--accent-primary);
            color: var(--accent-primary);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: var(--transition);
            backdrop-filter: blur(5px);
        }
        
        .control-btn:hover {
            background: var(--accent-primary);
            color: white;
            transform: scale(1.1);
        }
    </style>
</head>
<body>
    <!-- 视频背景 -->
    <video class="video-background" autoplay loop muted playsinline id="bg-video">
        
        <source src="${pageContext.request.contextPath}/resources/videos/zdm0.mp4" type="video/mp4">
        您的浏览器不支持视频标签。
    </video>
    

    
    <div class="container">
        <div class="header">
            <div class="brand">
                <div class="logo">M</div>
                <div class="brand-text">我的世界模组中心</div>
            </div>
            
            <div class="user-info">
                <span>欢迎：${ myUsername }（${ myRole }）</span>
                <a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> 退出游戏</a>
            </div>
        </div>
        
        <%
            request.setCharacterEncoding("UTF-8");
            String msg = "";    
            String label = "</span></div></body></html>";
            
            if (session.getAttribute("myRole") == null) {                     
                msg = "<div class='msg'><i class='fas fa-exclamation-circle'></i>您的登录已失效！请重新登录。" + 
                      "&emsp;<a href='index.jsp' style='color:var(--accent-primary);'>用户登录</a>" + label;    
                out.print(msg);
                return;
            }
            
            String myRole = session.getAttribute("myRole").toString();        
        %> 
        
        <!-- 玩家管理区域 -->
        <div class="section">
            <div class="section-title">
                <i class="fas fa-users"></i>
                <span>玩家管理</span>
            </div>
            
            <div class="card-grid">
                <div class="card">
                    <div class="card-title">
                        <i class="fas fa-user-circle"></i>
                        <span>个人资料</span>
                    </div>
                    <div class="card-desc">
                        查看和修改您的账户信息，包括用户名、角色权限和最后更新时间
                    </div>
                    <div class="card-actions">
                        <a href="userShow.jsp?userId=${ myUserId }" class="card-btn">
                            <i class="fas fa-eye"></i> 查看详情
                        </a>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-title">
                        <i class="fas fa-user-plus"></i>
                        <span>注册新用户</span>
                    </div>
                    <div class="card-desc">
                        邀请朋友加入服务器，创建新玩家账户并分配初始权限
                    </div>
                    <div class="card-actions">
                        <a href="userAdd.jsp" class="card-btn">
                            <i class="fas fa-plus"></i> 注册用户
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <%
            if (myRole.equals("user") || myRole.equals("admin")) { 
        %>
        <!-- 模组浏览区域 -->
        <div class="section">
            <div class="section-title">
                <i class="fas fa-cubes"></i>
                <span>模组浏览</span>
            </div>
            
            <div class="card-grid">
                <div class="card">
                    <div class="card-title">
                        <i class="fas fa-list"></i>
                        <span>全部模组</span>
                    </div>
                    <div class="card-desc">
                        浏览服务器所有可用模组，按照分类、版本和热度排序查看
                    </div>
                    <div class="card-actions">
                        <a href="modList.jsp" class="card-btn">
                            <i class="fas fa-search"></i> 查看列表
                        </a>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-title">
                        <i class="fas fa-fire"></i>
                        <span>热门模组</span>
                    </div>
                    <div class="card-desc">
                        发现服务器最受欢迎的模组，查看下载量和玩家评分
                    </div>
                    <div class="card-actions">
                        <a href="modPage.jsp" class="card-btn">
                            <i class="fas fa-chart-line"></i> 浏览热门
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <%
            }
            
            if (myRole.equals("admin")) { 
        %>
        <!-- 管理员区域 -->
        <div class="section">
            <div class="section-title">
                <i class="fas fa-cog"></i>
                <span>模组管理</span>
            </div>
            
            <div class="card-grid">
                <div class="card">
                    <div class="card-title">
                        <i class="fas fa-check-circle"></i>
                        <span>模组审核</span>
                    </div>
                    <div class="card-desc">
                        管理服务器所有模组，审核新提交的模组并更新现有模组信息
                    </div>
                    <div class="card-actions">
                        <a href="modAdmin.jsp" class="card-btn admin-btn">
                            <i class="fas fa-cog"></i> 模组管理
                        </a>
                        <a href="modAdd.jsp" class="card-btn">
                            <i class="fas fa-plus"></i> 添加模组
                        </a>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-title">
                        <i class="fas fa-user-shield"></i>
                        <span>用户管理</span>
                    </div>
                    <div class="card-desc">
                        管理服务器用户权限，重置密码、分配角色和审核新用户
                    </div>
                    <div class="card-actions">
                        <a href="userAdmin.jsp" class="card-btn admin-btn">
                            <i class="fas fa-users-cog"></i> 用户管理
                        </a>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-title">
                        <i class="fas fa-server"></i>
                        <span>服务器管理</span>
                    </div>
                    <div class="card-desc">
                        配置服务器参数，管理版本类型和设置系统选项
                    </div>
                    <div class="card-actions">
                        <a href="class/classAdmin.jsp" class="card-btn admin-btn">
                            <i class="fas fa-sliders-h"></i> 服务器配置
                        </a>
                        <a href="class/classAdd.jsp" class="card-btn">
                            <i class="fas fa-plus"></i> 添加版本
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <%
            }
            
            if (myRole.equals("guest")) {
        %>
        <div class="msg">
            <i class="fas fa-info-circle"></i>
            *注册之后，新用户（guest）还需获得管理员的授权，才能下载和使用模组。
        </div>        
        <% 
            }
        %>
    </div>
    
    
    
    <!-- 引入 particles.js -->
    <script src="https://cdn.jsdelivr.net/particles.js/2.0.0/particles.min.js"></script>
    <script>
        // 初始化粒子效果
        particlesJS("particles-js", {
            "particles": {
                "number": {
                    "value": 80,
                    "density": {
                        "enable": true,
                        "value_area": 800
                    }
                },
                "color": {
                    "value": "#3a86ff"
                },
                "shape": {
                    "type": "circle",
                    "stroke": {
                        "width": 0,
                        "color": "#000000"
                    }
                },
                "opacity": {
                    "value": 0.5,
                    "random": true,
                    "anim": {
                        "enable": true,
                        "speed": 1,
                        "opacity_min": 0.1,
                        "sync": false
                    }
                },
                "size": {
                    "value": 3,
                    "random": true,
                    "anim": {
                        "enable": true,
                        "speed": 2,
                        "size_min": 0.1,
                        "sync": false
                    }
                },
                "line_linked": {
                    "enable": true,
                    "distance": 150,
                    "color": "#5e60ce",
                    "opacity": 0.4,
                    "width": 1
                },
                "move": {
                    "enable": true,
                    "speed": 1,
                    "direction": "none",
                    "random": true,
                    "straight": false,
                    "out_mode": "out",
                    "bounce": false,
                    "attract": {
                        "enable": false,
                        "rotateX": 600,
                        "rotateY": 1200
                    }
                }
            },
            "interactivity": {
                "detect_on": "canvas",
                "events": {
                    "onhover": {
                        "enable": true,
                        "mode": "grab"
                    },
                    "onclick": {
                        "enable": true,
                        "mode": "push"
                    },
                    "resize": true
                },
                "modes": {
                    "grab": {
                        "distance": 140,
                        "line_linked": {
                            "opacity": 1
                        }
                    },
                    "push": {
                        "particles_nb": 4
                    }
                }
            },
            "retina_detect": true
        });
        
        // 视频控制功能
        const video = document.getElementById('bg-video');
        const playPauseBtn = document.getElementById('play-pause');
        const muteBtn = document.getElementById('mute-unmute');
        
        playPauseBtn.addEventListener('click', () => {
            if (video.paused) {
                video.play();
                playPauseBtn.innerHTML = '<i class="fas fa-pause"></i>';
            } else {
                video.pause();
                playPauseBtn.innerHTML = '<i class="fas fa-play"></i>';
            }
        });
        
        muteBtn.addEventListener('click', () => {
            if (video.muted) {
                video.muted = false;
                muteBtn.innerHTML = '<i class="fas fa-volume-up"></i>';
            } else {
                video.muted = true;
                muteBtn.innerHTML = '<i class="fas fa-volume-mute"></i>';
            }
        });
        
        // 卡片动画延迟
        document.querySelectorAll('.card').forEach((card, index) => {
            card.style.animationDelay = `${index * 0.1}s`;
        });
    </script>
</body>
</html>