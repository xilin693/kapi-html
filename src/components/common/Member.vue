<template>
    <el-container>
        <el-container>
            <el-table
                    :data="tableData"
                    :header-cell-style="{background:'#eef1f6',color:'#606266'}" :row-style="{height: '65px'}">
                <el-table-column
                        prop="name"
                        label="项目成员">
                </el-table-column>
                <el-table-column
                        label="权限">
                    <template slot-scope="scope">
                        <div slot="reference" class="name-wrapper">
                            <el-select v-model="scope.row.group" @change="selectChange(scope.row)" :disabled="disabled">
                                <el-option v-for="item in selectItem" :label="item.title" :value="item.id"></el-option>
                            </el-select>
                        </div>
                    </template>
                </el-table-column>
                <el-table-column label="操作">
                    <template slot-scope="scope" v-if="disabled == false">
                        <el-button @click="removeMember(scope.row.account_id)" type="danger">移除</el-button>
                    </template>
                </el-table-column>
                <el-table-column
                        align="right" v-if="disabled == false">
                    <template slot="header" slot-scope="scope">
                        <el-button @click="memberDialogVisible=true">添加成员</el-button>
                    </template>
                </el-table-column>
            </el-table>
        </el-container>
        <el-dialog title="添加成员" :visible.sync="memberDialogVisible" width="700px">
            <el-form :model="form" :rules="rules" ref="form">
                    <el-transfer v-model="form.hasAccount" :data="accounts" :titles="['所有成员', '目标成员']">
                        <el-button class="transfer-footer" slot="right-footer" size="small" @click="saveMember">批量加入</el-button>
                    </el-transfer>
                    <!--<el-select v-model="form.account_id" filterable>-->
                        <!--<el-option v-for="item in accounts" :key="item.id" :label="item.username"-->
                                   <!--:value="item.id">-->
                            <!--<span style="float: left">{{ item.username }}</span>-->
                            <!--<span style="float: right; color: #8492a6; font-size: 13px">{{ item.realname }}</span>-->
                        <!--</el-option>-->
                    <!--</el-select>-->
                <!--</el-form-item>-->
                <!--<el-form-item label="权限" :label-width="formLabelWidth" prop="group">-->
                    <!--<el-select v-model="form.group">-->
                        <!--<el-option v-for="item in selectItem" :label="item.title" :value="item.id"></el-option>-->
                    <!--</el-select>-->
                <!--</el-form-item>-->
                <!--<el-form-item>-->
                    <!--<div style="margin-left:100px">-->
                        <!--<el-button @click="memberDialogVisible = false">取 消</el-button>-->
                        <!--<el-button type="primary" @click="add()">确 定</el-button>-->
                    <!--</div>-->
            </el-form>
        </el-dialog>
        <el-footer>
            <div>
                <el-pagination
                        background
                        layout="prev, pager, next"
                        :total="total"
                        :current-page="currentPage"
                        :page-size="pageSize"
                        @current-change="handleList">
                </el-pagination>
            </div>
        </el-footer>
    </el-container>
</template>
<script>
    import {getNameList, userinfo} from '@/api/user';
    import {saveProjectMember, getProjectMember, updateProjectMember, getCurrentMember, removeMember} from '@/api/project';

    export default {
        name: 'ApiList',
        data() {
            return {
                account_id: 0,
                tableData: [],
                currentPage: 1,
                pageSize: 30,
                total: 0,
                userInfo: {},
                selectItem: [
                    {id: 1, title: '组长'},
                    {id: 2, title: '开发者'},
                    {id: 3, title: '访客'}
                ],
                form: {
                    group: 2,
                    account_id: '',
                    hasAccount: []
                },
                rules: {
                    account_id: [{
                        required: true,
                        message: '请选择开发者',
                        trigger: 'blur'
                    }],
                    group: [{
                        required: true,
                        message: '请选择权限组',
                        trigger: 'blur'
                    }],
                },
                formLabelWidth: '80px',
                memberDialogVisible: false,
                accounts: [],
                member: {},
                disabled: false
            }
        },
        props: ['projectId'],
        created() {
            this.init()
        },
        methods: {
            init() {
                let obj = {};
                getNameList({'project_id': this.$route.params.id}).then((rs) => {
                    rs.data.forEach((item) => {
                        obj.key = item.id;
                        obj.label = item.realname;
                        this.accounts.push(obj);
                        obj ={};
                    })
                });
                userinfo().then((rs) => {
                    this.userInfo = rs.data;
                    getCurrentMember({'account_id': this.userInfo.id, 'project_id': this.$route.params.id}).then((rs2) => {
                        this.member = rs2.data;
                        if (this.member.group !=1 && this.userInfo.id !=1) {
                            this.disabled = "disabled";
                        }
                    })
                });
                this.getList(1);
            },
            handleList(val){
                this.getList(val)
            },
            getList(val) {
                let obj = {};
                getProjectMember(this.$route.params.id, { page: val, per_page: this.pageSize }).then((rs) => {
                    this.tableData = rs.data.rs;
                    this.total = rs.data.total
                });
            },
            selectChange(row) {
                updateProjectMember({'id': row.id, 'group': row.group, 'project_id': this.$route.params.id}).then((rs) => {
                    this.$message.success('已更新')
                })
            },
            saveMember() {
                if (this.form.hasAccount < 1) {
                    this.$message.error('无用户');
                } else {
                    let data = [];
                    data.project_id = this.$route.params.id;
                    data.accounts = this.form.hasAccount;
                    saveProjectMember(data).then((rs) => {
                        this.$message.success('添加成功');
                        this.getList(1);
                        this.memberDialogVisible = false;
                    });
                }
            },
            removeMember(account_id) {
                removeMember({'account_id': account_id, 'project_id': this.$route.params.id}).then((rs) => {
                    this.$message.success('删除成功');
                    this.getList(1);
                });
            }
        }
    }
</script>
