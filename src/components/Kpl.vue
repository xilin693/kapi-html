<template>
    <el-container v-loading="loading">
        <el-header>
            <el-form :inline="true" v-model="form">
                <el-form-item label="接口筛选">
                    <el-date-picker
                            v-model="form.month"
                            type="month"
                            value-format="yyyy-MM"
                            placeholder="选择月">
                    </el-date-picker>
                </el-form-item>
                <el-form-item>
                    <el-input placeholder="请输入人员名称" v-model="form.realname"></el-input>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="handleClick">搜索</el-button>
                    <el-button @click="resetForm">重置</el-button>
                </el-form-item>
                <el-form-item>
                        <el-button @click="exportForm" type="success">导出</el-button>
                </el-form-item>
            </el-form>
        </el-header>
        <el-main>
            <el-form :model="listForm" ref="listForm">
                <el-table
                        :data="listForm.tableData"
                        style="width: 1100px">
                    <el-table-column
                            prop="month"
                            label="考核月份"
                            width="180">
                    </el-table-column>
                    <el-table-column
                            prop="realname"
                            label="姓名"
                            width="180">
                    </el-table-column>
                    <el-table-column
                            prop="my_score_sum"
                            label="自评"
                            width="180">
                    </el-table-column>
                    <el-table-column
                            prop="re_score_sum"
                            label="复评"
                            width="180">
                    </el-table-column>
                    <el-table-column
                            prop="final_score_sum"
                            label="终评"
                            width="180">
                        <template slot-scope="scope">
                            <div slot="reference" class="name-wrapper">
                                <el-input v-model="scope.row.final_score_sum"></el-input>
                            </div>
                        </template>
                    </el-table-column>
                    <el-table-column
                            prop="grade"
                            label="评级"
                            width="200">
                        <template slot-scope="scope">
                            <div slot="reference" class="name-wrapper">
                                <el-input v-model="scope.row.grade"></el-input>
                            </div>
                        </template>
                    </el-table-column>
                </el-table>
            </el-form>
        </el-main>
        <el-footer>
            <el-row style="width:1100px">
                <el-col :span="18">
                    <el-pagination
                            background
                            layout="prev, pager, next"
                            :total="total"
                            :current-page="currentPage"
                            :page-size="pageSize"
                            @current-change="handleCurrentChange"
                    >
                    </el-pagination>
                </el-col>
                <el-col :span="6">
                    <el-button type="primary" @click="sumbitForm">更新</el-button>
                </el-col>
            </el-row>
        </el-footer>
    </el-container>
</template>

<script>
    import {getAllKpi, saveAllKpi, exportExcel} from '@/api/kpi'

    export default {
        data() {
            return {
                form: {
                    month: '',
                    realname: '',
                },
                listForm: {
                    tableData: [],
                },
                currentPage: 1,
                pageSize: 10,
                total: 0,
                loading: false,
                jsonData: [],
                jsonFields: {
                    '日期': 'ctime',
                    '姓名': 'realname',
                    '自评': 'my_score_sum',
                    '复评': 're_score_sum',
                    '终评': 'final_score_sum',
                    '评级': 'grade',
                },
                jsonMeta: [
                    [
                        {
                            key: "charset",
                            value: "utf-8",
                        },
                    ]
                ]
            }
        },
        created() {
            this.init()
        },
        methods: {
            init() {
                this.getList(1)
            },
            handleClick() {
                this.getList(1);
            },
            resetForm() {
                this.form.month = '';
                this.form.realname = '';
                this.getList(1);
            },
            handleCurrentChange(val) {
                this.getList(val)
            },
            getList(val) {
                let params = this.form;
                params.page = val;
                this.currentPage = val;
                params.per_page = this.pageSize;
                getAllKpi(params).then((rs) => {
                    this.listForm.tableData = rs.data.rs;
                    this.total = rs.data.total;
                    this.loading = false;
                });
            },
            sumbitForm() {
                saveAllKpi(this.listForm).then((rs) => {
                    this.$message.success('更新成功');
                })
            },
            exportForm() {
                let params = {};
                params.month = this.form.month;
                exportExcel(params).then((rs) => {

                    let data = rs.data
                    let tableInfo = ['ctime', 'realname', 'my_score_sum', 're_score_sum', 'final_score_sum', 'grade']
                    let header = ['日期', '姓名', '自评', '复评', '终评', '评级']
                    let val = []
                    data.forEach(kpi => {
                        const item = {
                            ctime: kpi.ctime,
                            realname: kpi.realname,
                            my_score_sum: kpi.my_score_sum,
                            re_score_sum: kpi.re_score_sum,
                            final_score_sum: kpi.final_score_sum,
                            grade: kpi.grade
                        }
                        val.push(item)
                    })
                    let filename = '绩效考核' + this.form.month
                    this.utils.exportExcel(tableInfo, header, val, filename)

                })

            }
        }
    }
</script>
