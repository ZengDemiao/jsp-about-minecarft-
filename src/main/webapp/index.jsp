<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的世界 - 用户登录</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            margin: 0;
            padding: 0;
            overflow: hidden;
            font-family: 'Minecraft', Arial, sans-serif;
            color: #fff;
            text-shadow: 2px 2px 4px #000;
            position: relative;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(rgba(0, 20, 0, 0.7), rgba(0, 0, 20, 0.7));
        }
        
        .video-background {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: -3;
        }

        @font-face {
            font-family: 'Minecraft';
            src: url('https://fonts.cdnfonts.com/css/minecraft-4') format('woff');
        }

        .container {
            width: 400px;
            margin: 50px auto;
            background-color: rgba(0, 0, 0, 0.75);
            border: 6px solid #5a5a5a;
            border-radius: 2px;
            padding: 30px;
            box-shadow: 0 8px 0 rgba(0,0,0,0.5), 0 0 20px rgba(0, 0, 0, 0.8);
            position: relative;
            z-index: 1;
            backdrop-filter: blur(4px);
            transform: translateY(-20px);
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(-20px); }
            50% { transform: translateY(-25px); }
        }

        h3 {
            text-align: center;
            font-size: 28px;
            color: #55ff55;
            margin-bottom: 30px;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .minecraft-input {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            background-color: #222;
            border: 4px solid #5a5a5a;
            border-radius: 2px;
            color: #fff;
            font-family: 'Minecraft', Arial, sans-serif;
            font-size: 16px;
            transition: all 0.2s ease;
            box-shadow: 0 4px 0 #333;
        }
        
        .minecraft-input:focus {
            outline: none;
            border-color: #FFD700;
            box-shadow: 0 4px 0 #555, 0 0 10px rgba(255, 215, 0, 0.5);
            transform: translateY(-2px);
        }
        
        .minecraft-input:hover {
            border-color: #888;
        }

        .minecraft-btn {
            padding: 12px 24px;
            background-color: #4CAF50;
            border: 4px solid #2d672f;
            border-radius: 2px;
            color: white;
            font-family: 'Minecraft', Arial, sans-serif;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.1s ease;
            box-shadow: 0 4px 0 #2d672f;
            margin-right: 15px;
            letter-spacing: 1px;
        }
        
        .minecraft-btn:hover {
            background-color: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 6px 0 #2d672f;
        }
        
        .minecraft-btn:active {
            transform: translateY(2px);
            box-shadow: 0 2px 0 #2d672f;
        }

        .msg {
            color: #ff5555;
            font-size: 16px;
            display: inline-block;
            min-height: 20px;
            padding: 0 10px;
        }

        .pixel-creeper {
            text-align: center;
            margin-bottom: 20px;
            font-size: 24px;
            color: #55ff55;
            text-shadow: 0 0 10px #00ff00;
            animation: glow 2s ease-in-out infinite alternate;
        }

        @keyframes glow {
            from { text-shadow: 0 0 5px #00ff00; }
            to { text-shadow: 0 0 20px #00ff00, 0 0 30px #00ff00; }
        }

        .register-link {
            display: block;
            color: #55aaff;
            text-decoration: none;
            margin: 15px 0;
            font-size: 16px;
            text-align: center;
            transition: all 0.3s;
        }

        .register-link:hover {
            text-decoration: underline;
            color: #aaffff;
            transform: scale(1.05);
        }

        .note {
            display: block;
            color: #aaa;
            font-size: 14px;
            margin-top: 20px;
            line-height: 1.5;
            border-top: 1px solid #5a5a5a;
            padding-top: 15px;
            text-align: center;
        }

        .input-label {
            display: block;
            margin: 15px 0 5px;
            color: #55ff55;
            font-size: 16px;
        }
        
        /* 声音控制按钮样式 */
        .sound-toggle {
            position: fixed;
            top: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: rgba(0, 0, 0, 0.7);
            border: 4px solid #5a5a5a;
            box-shadow: 0 4px 0 #333, 0 0 15px rgba(0, 0, 0, 0.8);
            cursor: pointer;
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 10;
            transition: all 0.3s ease;
        }
        
        .sound-toggle:hover {
            transform: scale(1.1);
            background: rgba(0, 0, 0, 0.85);
            border-color: #888;
            box-shadow: 0 6px 0 #333, 0 0 20px rgba(85, 255, 85, 0.7);
        }
        
        .sound-icon {
            font-size: 28px;
            color: #55ff55;
            transition: all 0.3s ease;
        }
        
        .sound-toggle.muted .sound-icon {
            color: #ff5555;
        }
        
        /* 旋转动画 */
        .sound-toggle.playing {
            animation: rotate 3s linear infinite;
        }
        
        @keyframes rotate {
            from {
                transform: rotate(0deg);
            }
            to {
                transform: rotate(360deg);
            }
        }
        
        /* 脉冲效果 */
        .pulse-ring {
            position: absolute;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            border: 2px solid #55ff55;
            opacity: 0;
            animation: pulse 2s infinite;
        }
        
        .sound-toggle.muted .pulse-ring {
            border-color: #ff5555;
            animation: none;
        }
        
        @keyframes pulse {
            0% {
                transform: scale(0.8);
                opacity: 0.7;
            }
            100% {
                transform: scale(1.5);
                opacity: 0;
            }
        }
        
        /* 响应式设计 */
        @media (max-width: 500px) {
            .container {
                width: 90%;
                margin: 20px auto;
                padding: 20px;
            }
            
            .sound-toggle {
                top: 20px;
                right: 20px;
                width: 50px;
                height: 50px;
            }
            
            .sound-icon {
                font-size: 24px;
            }
            
            h3 {
                font-size: 24px;
            }
        }
        
        .particles {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -2;
            overflow: hidden;
        }
        
        .particle {
            position: absolute;
            background-color: #55ff55;
            border-radius: 50%;
            opacity: 0.5;
            animation: floatParticle linear infinite;
        }
        
        @keyframes floatParticle {
            to {
                transform: translateY(-100px) rotate(360deg);
                opacity: 0;
            }
        }
    </style>
</head>

<body>
    <!-- 声音控制按钮 -->
    <div class="sound-toggle" id="soundToggle">
        <div class="sound-icon">🔇</div>
        <div class="pulse-ring"></div>
    </div>
    
    <div class="container">
        <div class="pixel-creeper">⛏️ MINECRAFT LOGIN ⛏️</div>
        <h3>用户登录</h3>
        <form action="loginCheck.jsp" method="post">
            <span class="input-label">用户名：</span>
            <input type="text" name="username" class="minecraft-input" value="${username}" placeholder="输入您的游戏ID">
            
            <span class="input-label">密码：</span>
            <input type="password" name="password" class="minecraft-input" value="${password}" placeholder="输入您的密码">
            
            <div style="margin: 20px 0; text-align: center;">
                <input type="submit" value="进入世界" class="minecraft-btn">
                <span class="msg">${msg}</span>
            </div>
            
            <a href="userAdd.jsp" class="register-link">新玩家注册</a>
            
            <span class="note">
                普通用户角色user登录：levi，1<br>
                管理员角色admin登录：ALBUM，1
            </span>
        </form>
    </div>
    
    <video class="video-background" id="bgVideo" autoplay loop muted playsinline>
        <source src="${pageContext.request.contextPath}/resources/videos/zdm0.mp4" type="video/mp4">
        您的浏览器不支持视频标签。
    </video>
    
    <div class="particles" id="particles"></div>
    
    <script>
        // 声音控制功能
        const soundToggle = document.getElementById('soundToggle');
        const bgVideo = document.getElementById('bgVideo');
        const soundIcon = soundToggle.querySelector('.sound-icon');
        
        // 初始状态（静音）
        let isMuted = true;
        
        // 添加点击事件监听器
        soundToggle.addEventListener('click', () => {
            isMuted = !isMuted;
            bgVideo.muted = isMuted;
            
            // 更新按钮状态
            if (isMuted) {
                soundToggle.classList.remove('playing');
                soundToggle.classList.add('muted');
                soundIcon.textContent = '🔇';
            } else {
                soundToggle.classList.add('playing');
                soundToggle.classList.remove('muted');
                soundIcon.textContent = '🔊';
            }
        });
        
        // 创建粒子背景
        function createParticles() {
            const particlesContainer = document.getElementById('particles');
            const particleCount = 50;
            
            for (let i = 0; i < particleCount; i++) {
                const particle = document.createElement('div');
                particle.classList.add('particle');
                
                // 随机大小 (1px 到 4px)
                const size = Math.random() * 3 + 1;
                particle.style.width = `${size}px`;
                particle.style.height = `${size}px`;
                
                // 随机位置
                const posX = Math.random() * 100;
                particle.style.left = `${posX}%`;
                
                // 随机颜色
                const colors = ['#55ff55', '#55aaff', '#ffaa55', '#ff55ff'];
                const color = colors[Math.floor(Math.random() * colors.length)];
                particle.style.backgroundColor = color;
                
                // 随机动画时长
                const duration = Math.random() * 10 + 5;
                particle.style.animationDuration = `${duration}s`;
                
                // 随机延迟
                const delay = Math.random() * 5;
                particle.style.animationDelay = `${delay}s`;
                
                particlesContainer.appendChild(particle);
            }
        }
        
        // 页面加载完成后执行
        window.onload = function() {
            createParticles();
        };
    </script>
</body>
</html>