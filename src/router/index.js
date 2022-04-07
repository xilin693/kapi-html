import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/components/Home'
import Dashboard from '@/components/Dashboard'
import Project from '@/components/Project'
import Apis from '@/components/Apis'
import Manage from '@/components/Manage'
import Item from '@/components/Item'
import Password from '@/components/Password'
import Import from '@/components/Import'
import Kpi from '@/components/Kpi'
import Org from '@/components/Org'
import History from '@/components/History'
import Kpl from '@/components/Kpl'

const Login = resolve => require(['@/components/Login'], resolve)

Vue.use(Router)

const router = new Router({
    // mode: 'history',
    routes: [{
        path: '/',
        component: Home,
        redirect: '/dashboard',
        name: '首页',
        leaf: true,
        menuShow: true,
        iconCls: 'icon-home',
        children: [{
            path: '/dashboard',
            component: Dashboard,
            name: '首页',
            menuShow: true
        }, {
            path: '/project/:id',
            component: Project,
            name: '项目列表',
            menuShow: true

        }, {
            path: '/manage/',
            component: Manage,
            name: '管理员设置',
            menuShow: true
        }, {
            path: '/item/',
            component: Item,
            name: '新增项目',
            menuShow: true
        }, {
            path: '/password/',
            component: Password,
            name: '修改密码',
            menuShow: true
        }, {
            path: '/import/',
            component: Import,
            name: '修改密码',
            menuShow: true
        }, {
            path: '/kpi/',
            component: Kpi,
            name: '绩效考核',
            menuShow: true
        }, {
            path: '/org/',
            component: Org,
            name: '项目组织结构',
            menuShow: true
        }, {
            path: '/history/',
            component: History,
            name: '历史绩效',
            menuShow: true
        }, {
            path: '/kpl/',
            component: Kpl,
            name: '绩效列表',
            menuShow: true
        }]
    }, {
        path: '/login',
        name: '登录',
        component: Login
    }, {
        path: '/apis/:id',
        component: Apis,
        name: '接口列表',
        menuShow: true
    }]
})

const originalPush = Router.prototype.push
Router.prototype.push = function push(location) {
    return originalPush.call(this, location).catch(err => err)
}

export default router
