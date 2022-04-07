<template>
    <el-col class="topbar-wrap">
        <div class="topbar-logo topbar-btn">
            <a href="/"></a>
        </div>
        <div class="topbar-logos">
            <a href="/"></a>
        </div>
        <div class="topbar-title">
            <a href="/"><span style="font-size: 18px;color: #fff;">Kapi接口服务 <span id="pn">{{projectName}}</span></span></a>
        </div>
        <div class="topbar-account topbar-btn">
            <el-dropdown class="avatar-container" trigger="click">
                <div class="avatar-wrapper">
                    <img :src="defaultImg" class="user-avatar"/>
                    <span class="name">{{this.userinfo.username}}</span>
                    <i class="el-icon-caret-bottom"/>
                </div>
                <el-dropdown-menu slot="dropdown" class="user-dropdown">
                    <router-link to="/">
                        <el-dropdown-item>首页</el-dropdown-item>
                    </router-link>
                    <el-dropdown-item @click.native="updatePassword">修改密码</el-dropdown-item>
                    <template v-if="userinfo.id == 1">
                        <el-dropdown-item @click.native="manage">管理员设置</el-dropdown-item>
                    </template>
                    <el-dropdown-item divided @click.native="logout">退出</el-dropdown-item>
                </el-dropdown-menu>
            </el-dropdown>
        </div>
    </el-col>
</template>
<script>
    import { userinfo, delSession } from '@/api/user';
    import { removeToken } from '@/utils/auth';
    import {getCurrentProject} from '@/api/project';
    export default {
        name: 'TopBar',
        data() {
            return {
                defaultImg: require('@/assets/image/avatar.png'),
                userinfo: {},
                projectName: ''
            }
        },
        created() {
            this.init()
        },
        methods: {
            init() {
                if (this.$route.params.id > 0) {
                    getCurrentProject(this.$route.params.id).then((rs) => {
                        sessionStorage.setItem("postUseJson", rs.data.post_use_json);
                        this.projectName = '- ' + rs.data.name;
                    });
                }
                userinfo().then(rs => {
                    this.userinfo = rs.data
                }).catch(() => {
                    this.$router.push('/login')
                })
            },
            logout() {
                delSession().then(() => {
                    removeToken()
                })
                this.$router.push('/login')
            },
            manage() {
                this.$router.push('/manage')
            },
            updatePassword() {
                this.$router.push('/password')
            }
        }
    }
</script>

<style scoped lang="scss">
    .topbar-wrap {
        height: 60px;
        line-height: 50px;
        background: #373d41;
        padding: 0px;

        .topbar-btn {
            color: #fff;
        }
        .topbar-title {
            float: left;
            text-align: left;
            width: 500px;
            padding-left: 10px;
            border-left: 1px solid #000;
        }
        .topbar-account {
            float: right;
            padding-right: 12px;
        }
        .userinfo-inner {
            cursor: pointer;
            color: #fff;
            padding-left: 10px;
        }
    }

    .avatar-container {
        margin-right: 30px;

        .avatar-wrapper {
            margin-top: 5px;
            position: relative;

            .name {
                transform: translateY(-5px);
                cursor: pointer;
                display: inline-block;
                color: #fff
            }
            .user-avatar {
                cursor: pointer;
                width: 40px;
                height: 40px;
                border-radius: 10px;
            }

            .el-icon-caret-bottom {
                cursor: pointer;
                position: absolute;
                right: -20px;
                top: 25px;
                font-size: 12px;
            }
        }
    }
</style>
