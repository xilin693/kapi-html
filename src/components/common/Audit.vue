<template>
    <el-container>
        <el-container>
            <el-table
                    :data="tableData"
                    :header-cell-style="{background:'#eef1f6',color:'#606266'}" :row-style="{height: '65px'}">
                <el-table-column
                        prop="username"
                        label="未审核会员">
                </el-table-column>
                <el-table-column
                        prop="realname"
                        label="真实姓名">
                </el-table-column>
                <el-table-column
                        label="审核">
                    <template slot-scope="scope">
                        <div slot="reference" class="name-wrapper">
                            <el-select v-model="scope.row.audit" @change="selectChange(scope.row)" value-key="item.id">
                                <el-option v-for="item in selectItem" :label="item.title" :value="item.id"></el-option>
                            </el-select>
                        </div>
                    </template>
                </el-table-column>
            </el-table>
        </el-container>
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
        <el-dialog title="设置用户分组" :visible.sync="roleVisible" width="400px">
            <el-divider></el-divider>
            <el-form :model="form">
            <el-form-item label="分组名称" :label-width="formLabelWidth">
                <el-select v-model="form.role">
                    <el-option v-for="item in roles" :key="item.id" :label="item.name"
                               :value="item.id"></el-option>
                </el-select>
            </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button @click="roleVisible = false; getList(1)">取 消</el-button>
                <el-button type="primary" @click.native="addRole">确 定</el-button>
            </div>
        </el-dialog>
    </el-container>

</template>
<script>
    import {getAuditList, updateAccount} from '@/api/user';

    export default {
        name: 'Audit',
        data() {
            return {
                account_id: 0,
                tableData: [],
                currentPage: 1,
                pageSize: 10,
                total: 0,
                selectItem: [
                    {id: 0, title: '待审核'},
                    {id: 1, title: '审核通过'},
                    {id: -1, title: '审核不通过'}
                ],
                roleVisible: false,
                form: {
                    role:1,
                    id: 0
                },
                roles: [{"name":"后端", "id": 1}, {"name":"前端/客户端", "id": 2}, {"name":"测试/其他", "id": 3}],
                formLabelWidth: '80px',
                time:null
            }
        },
        created() {
            // this.time = setInterval(()=>{
            this.init();
            // }, 3000)
        },
        methods: {
            init() {
                this.getList(1);
            },
            handleList(val){
                this.getList(val)
            },
            getList(val) {
                getAuditList({ page: val, per_page: this.pageSize }).then((rs) => {
                    this.tableData = rs.data.rs;
                    this.total = rs.data.total
                });
            },
            selectChange(row) {
                if (row.audit == 1) {
                    this.form.id = row.id;
                    this.roleVisible = true;
                } else {
                    updateAccount({'id': row.id, 'audit': row.audit}).then(() => {
                        this.$message.success('已更新')
                    })
                }
            },
            addRole() {
                updateAccount({'id': this.form.id, 'audit': 1, 'role_id': this.form.role}).then(() => {
                    this.$message.success('已更新');
                    this.roleVisible = false;
                    this.getList(1);
                })
            }
        }
        // beforeDestroy : function () {
        //     let that = this;
        //     clearInterval(that.time);
        // }
    }
</script>
