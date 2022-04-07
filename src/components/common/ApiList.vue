<template>
    <el-container>
        <el-header>
            <el-form :inline="true" v-model="form" @keyup.enter.native="handleClick">
                <el-form-item label="接口筛选">
                    <el-select v-model="form.account_id" placeholder="请选择开发者">
                        <el-option
                                v-for="item in accounts"
                                :key="item.id"
                                :label="item.realname"
                                :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item>
                    <el-select width="80px" v-model="form.method" placeholder="请选择接口方法">
                        <el-option label="GET" value="get"></el-option>
                        <el-option label="POST" value="post"></el-option>
                        <el-option label="PUT" value="put"></el-option>
                        <el-option label="DELETE" value="delete"></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item>
                    <el-input placeholder="请输入接口名称或网址" v-model="form.uri"></el-input>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="handleClick">搜索</el-button>
                    <el-button @click="resetForm()">全部接口</el-button>
                </el-form-item>
            </el-form>
        </el-header>
        <el-container>
            <el-table
                    :data="tableData"
                    :header-cell-style="{background:'#eef1f6',color:'#606266'}" :row-style="{height: '65px'}"
                    v-loading="loading">
                <el-table-column
                        prop="name"
                        label="接口名称"
                        min-width="20%">
                    <template slot-scope="scope">
                        <span @click="jump(scope.row.id)" style="cursor:pointer; color:#409eff">{{scope.row.name}}</span>
                    </template>
                </el-table-column>
                <el-table-column
                        label="接口路径"
                        min-width="25%">
                    <template slot-scope="scope">
                            <div slot="reference" class="name-wrapper">
                                <template v-if="scope.row.method == 'get'">
                                <el-tag>GET</el-tag> {{ scope.row.uri }}
                                </template>
                                <template v-else-if="scope.row.method == 'post'">
                                <el-tag type="success">POST</el-tag> {{ scope.row.uri }}
                                </template>
                                <template v-else-if="scope.row.method == 'put'">
                                    <el-tag type="info">PUT</el-tag> {{ scope.row.uri }}
                                </template>
                                <template v-else>
                                    <el-tag type="danger">DELETE</el-tag> {{ scope.row.uri }}
                                </template>
                            </div>
                    </template>
                </el-table-column>
                <el-table-column
                        label="开发者"
                        min-width="15%"
                        prop="realname">
                </el-table-column>
                <el-table-column
                        prop="category"
                        label="接口分类"
                        min-width="15%">
                </el-table-column>
                <el-table-column
                        label="接口状态"
                        min-width="15%">
                    <template slot-scope="scope">
                    <div slot="reference" class="name-wrapper">
                        <el-select v-model="scope.row.complete" @change="selectChange(scope.row)">
                            <el-option v-for="item in selectItem" :label="item.title" :value="item.id"></el-option>
                        </el-select>
                    </div>
                    </template>
                </el-table-column>
            </el-table>
        </el-container>
        <el-container>
            <el-pagination
                    background
                    layout="prev, pager, next"
                    :total="total"
                    :current-page="currentPage"
                    :page-size="pageSize"
                    @current-change="handleCurrentChange"
            >
            </el-pagination>
        </el-container>
    </el-container>
</template>
<script>
    import { getApiList, setApiField, searchApi } from '@/api/apis'
    import { getProjectAccount } from '@/api/project'

    export default {
        name: 'ApiList',
        data() {
            return {
                loading: false,
                account_id: 0,
                tableData: [],
                currentPage: 1,
                pageSize: 20,
                total: 0,
                form: {
                    'account_id': '',
                    'method': '',
                    'uri': '',
                    'status': [],
                },
                accounts: '',
                selectItem: [
                    {id: 0, title: '未完成'},
                    {id: 1, title: '已完成'}
                ]
            }
        },
        props: ['projectId'],
        created() {
            this.init()
        },
        methods: {
            init() {
                this.getList(1)
                getProjectAccount({ id: this.projectId}).then(rs => {
                    this.accounts = rs.data
                })
            },
            jump(id) {
                this.$emit('changeDetail', id)
            },
            handleCurrentChange(val) {
                this.getList(val)
            },
            getList(val) {
                // getApiList(this.projectId, { page: val, per_page: this.pageSize }).then((res) => {
                //     this.tableData = res.data.rs
                //     this.total = res.data.total
                // })
                this.loading = true;
                let data = {...this.form};
                data.project_id = this.projectId;
                data.page = val;
                this.currentPage = val;
                data.per_page = this.pageSize;
                searchApi(data).then(res => {
                    this.tableData = res.data.rs;
                    this.total = res.data.total;
                    this.loading = false;
                })
            },
            selectChange(row) {
                setApiField({ id: row.id, complete: row.complete }).then((rs) => {
                    this.$message('更新成功')
                })
            },
            handleClick() {
                this.loading = true;
                this.getList(1);
            },
            resetForm() {
                this.form = {
                    'accounts': '',
                    'method': '',
                    'uri': '',
                    'status': []
                }
                this.getList(1);
            }
        }
    }
</script>
