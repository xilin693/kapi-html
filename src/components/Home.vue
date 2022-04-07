<template>
<el-container class="container">
    <el-header>
        <topBar></topBar>
    </el-header>
    <el-container>
        <aside>
            <div class="menu-toggle" @click.prevent="collapse">
                <el-button size="small" @click.stop="addProject" type="success">添加项目</el-button>
                <el-button size="small" @click.stop="importProject" type="primary">导入导出</el-button>
            </div>
            <el-scrollbar wrap-class="scrollbar-wrapper" class="myscrollbar">
            <el-menu
                    default-active="7"
                    class="el-menu-vertical-demo"
                    background-color="#333744"
                    text-color="#fff"
                    active-text-color="#409eff">
                <template v-for="(item, index) in nav" :key2="index">
                <el-menu-item @click="changeList(item.id)" :index="item.id.toString()" style="width: 260px">
                    <i class="el-icon-document"></i>
                    <span slot="title">{{ item.name }}</span>
                </el-menu-item>
                </template>
            </el-menu>
            </el-scrollbar>
        </aside>
        <el-main>
            <router-view :key="$route.params.id"></router-view>
        </el-main>
    </el-container>
</el-container>
</template>
<script>
import { getNavGroup } from '@/api/project'
import { setRoute } from '@/utils/auth'
import TopBar from '@/components/common/TopBar'

export default {
    data() {
        return {
            nav: [],
            defaultImg: require('@/assets/image/avatar.png'),
            name: ''
        }
    },
    created() {
        this.init()
    },
    components: {
        TopBar
    },
    methods: {
        init() {
            getNavGroup().then(res2 => {
                this.nav = res2.data
                setRoute(JSON.stringify(res2.data))
            })
        },
        changeList(id) {
            if (id == 7) {
                this.$router.push('/dashboard')
            } else {
                this.$router.push('/project/' + id)
            }
        },
        addProject() {
            this.$router.push('/item')
        },
        importProject() {
            this.$router.push('/import')
        }
    }
}

</script>
<style scoped lang="scss">
    .el-header {
        padding:0px;
    }
    .container {
        position: absolute;
        top: 0px;
        bottom: 0px;
        width: 100%;

        .main {
            display: -webkit-box;
            display: -webkit-flex;
            display: -ms-flexbox;
            display: flex;
            position: absolute;
            top: 50px;
            bottom: 0px;
            overflow: hidden;
        }

        aside {
            width: 260px !important;
            background: #333744;
            &::-webkit-scrollbar {
                display: none;
            }

            &.showSidebar {
                overflow-x: hidden;
                overflow-y: auto;
            }

            .el-menu {
                height: 100%; /*写给不支持calc()的浏览器*/
                height: -moz-calc(100% - 80px);
                height: -webkit-calc(100% - 80px);
                height: calc(100% - 80px);
                border-radius: 0px;
                background-color: #333744;
                border-right: 0px;
            }

            .el-submenu .el-menu-item {
                min-width: 60px;
            }
            .el-menu {
                width: 260px;
            }
            .el-menu--collapse {
                width: 60px;
            }

            .el-menu .el-menu-item, .el-submenu .el-submenu__title {
                height: 46px;
                line-height: 46px;
            }

            .el-menu-item:hover, .el-submenu .el-menu-item:hover, .el-submenu__title:hover {
                background-color: #7ed2df;
            }
        }

        .myscrollbar{
            height: calc(100vh - 100px);
        }
        .myscrollbar>>>.el-scrollbar__wrap{
            overflow-x: hidden;
        }

        .menu-toggle {
            background: #4A5064;
            text-align: left;
            color: white;
            height: 40px;
            line-height: 40px;
            padding-left:10px;
        }

        .content-container {
            background: #fff;
            flex: 1;
            overflow-y: auto;
            padding: 10px;
            padding-bottom: 1px;

            .content-wrapper {
                background-color: #fff;
                box-sizing: border-box;
            }
        }
    }

</style>
