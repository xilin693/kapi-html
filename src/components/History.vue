<template>
    <el-container>
        <el-main>
            <template>
                <el-table
                        :data="tableData"
                        style="width: 920px">
                    <el-table-column
                            prop="month"
                            label="日期"
                            width="180">
                    </el-table-column>
                    <el-table-column
                            prop="my_score_sum"
                            label="自评"
                            width="180">
                    </el-table-column>
                    <el-table-column
                            prop="re_score_sum"
                            label="主管/项目经理复评"
                            width="180">
                    </el-table-column>
                    <el-table-column
                            prop="final_score_sum"
                            label="部门经理终评"
                            width="180">
                    </el-table-column>
                    <el-table-column
                            prop="grade"
                            label="评级"
                            width="200">
                    </el-table-column>
                </el-table>
            </template>
        </el-main>
        <el-footer>
            <el-pagination
                    background
                    layout="prev, pager, next"
                    :total="total"
                    :current-page="currentPage"
                    :page-size="pageSize"
                    @current-change="handleCurrentChange"
            >
            </el-pagination>
        </el-footer>
    </el-container>
</template>

<script>
    import {getMyKpi} from '@/api/kpi'

    export default {
        data() {
            return {
                tableData: [],
                currentPage: 1,
                pageSize: 10,
                total: 0,
                loading: true
            }
        },
        created() {
            this.init()
        },
        methods: {
            init() {
                this.getList(1)
            },
            handleCurrentChange(val) {
                this.getList(val)
            },
            getList(val) {
                let params = {};
                params.page = val;
                this.currentPage = val;
                params.per_page = this.pageSize;
                getMyKpi(params).then((rs) => {
                    this.tableData = rs.data.rs;
                    this.total = rs.data.total;
                    this.loading = false;
                });
            }
        }
    }
</script>
