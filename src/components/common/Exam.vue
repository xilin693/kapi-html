<template>
    <el-container>
        <el-form :model="form" ref="form">
            <el-form-item style="color: cornflowerblue">
                <el-row style=" margin-bottom: 20px; ">
                    <el-col :span="4">
                        真实姓名: <span class="nameStyle">{{this.realname}}</span>
                    </el-col>
                    <el-col :span="12"></el-col>
                    <el-col :span="6">
                        当前日期:<span class="nameStyle">{{this.utils.switchTime()}}</span>
                    </el-col>
                </el-row>
            </el-form-item>
            <el-form-item>
                <el-table
                        :data="tableData"
                        stripe
                        style="width: 100%">
                    <el-table-column
                            prop="item"
                            label="考核项目"
                            width="200">
                    </el-table-column>
                    <el-table-column
                            prop="score"
                            label="总分"
                            width="200">
                    </el-table-column>
                    <el-table-column
                            prop="option"
                            label="考核指标"
                            width="400">
                        <template slot-scope="scope">
                            <div v-html="scope.row.option"></div>
                        </template>
                    </el-table-column>
                    <el-table-column
                            prop="my_score"
                            label="自评" width="200">
                        <template slot-scope="scope">
                            <div v-if="!checkMySum">
                                <el-input v-model.number="form.my_score[scope.$index]"
                                          @input="appendScore('my_score')"></el-input>
                            </div>
                            <div v-else>
                                <span>{{form.my_score[scope.$index]}}</span>
                            </div>
                        </template>
                    </el-table-column>
                    <el-table-column
                            prop="re_score"
                            label="复评" width="200" v-if="edit=='re'">
                        <template slot-scope="scope" v-if="form.re_score">
                            <div v-if="!checkReSum">
                                <el-input v-model.number="form.re_score[scope.$index]"
                                          @input="appendScore('re_score')"></el-input>
                            </div>
                            <div v-else>
                                <span>{{form.re_score[scope.$index]}}</span>
                            </div>
                        </template>
                    </el-table-column>
                </el-table>
            </el-form-item>
            <el-form-item>
                <el-row>
                    <el-col :span="16">
                        <template v-if="(edit =='my' && checkMySum == 0) || (edit =='re' && checkReSum == 0)">
                            <el-button type="primary" @click="submitForm">提交</el-button>
                        </template>
                    </el-col>
                    <el-col :span="4">
                        总分&nbsp;:&nbsp;<span>{{form.my_score_sum}}</span>

                    </el-col>
                    <el-col :span="4" v-if="edit=='re'">
                        总分&nbsp;:&nbsp;<span>{{form.re_score_sum}}</span>

                    </el-col>
                </el-row>
            </el-form-item>
        </el-form>
    </el-container>
</template>
<style>
    .nameStyle {
        border-bottom: 1px solid #ccc;
        color: #000;
        padding: 5px;
    }
</style>
<script>
    import {saveKpi, getKpi} from '@/api/kpi';

    export default {
        data() {
            return {
                userInfo: {},
                checkMySum: 0,
                checkReSum: 0,
                tableData: [{
                    item: '工作品质',
                    score: '30',
                    option: '1、所承接的工作量(8)<br/> \
                    2、工作所完成的质量,工作效率(10)<br/> \
                    3、规定时间内完成(8)<br/> \
                    4、代码及文档规范/质量(4)',
                }, {
                    item: '工作积极性',
                    score: '30',
                    option: '1、时间都花在公司的项目或项目相关的内容上<br/> \
                    ,能自主加班,尽量提前完成(10)<br/>\
                    2、本月在工作中有明显进步,个人技能得到提升(10)<br/> \
                    3、是否能逐渐承接更困难的工作(5)<br/> \
                    4、工作量较低时能主动要求承接工作(5)<br/>',
                }, {
                    item: '团队合作',
                    score: '15',
                    option: '1、当任务与他人有交集时,能否与他人沟通协调,确认<br/> \
                    好各自对需求的理解,并在过程中持续跟进功能完成情况(5)<br/> \
                    2、合理化建议(5)<br/> \
                    3、尽职,不因个人原因影响团队效率或项目进度(5)',
                }, {
                    item: '向上管理',
                    score: '10',
                    option: '1、是否经常主动反馈工作进度及遇到的问题(5)<br/> \
                    2、是否提供创新的思维提升了项目质量(5)',
                }, {
                    item: '沟通能力',
                    score: '15',
                    option: '1、与其他部门同事沟通状况(5)<br/> \
                    2、与直属上级的沟通状况(5)<br/> \
                    3、服从管理,能主动沟通(5)',
                }],
                form: {
                    account_id: 0,
                    my_score_sum: 0,
                    re_score_sum: 0,
                    my_score: ['', '', '', '', ''],
                    re_score: ['', '', '', '', ''],
                },
            }
        },
        props: ['edit', 'userId', 'realname'],
        created() {
            this.init();
        },
        methods: {
            init() {
                getKpi({'id': this.userId}).then((rs) => {
                    if (!rs.data.my_score) {
                        this.form.my_score = ['', '', '', '', ''];
                        this.form.my_score_sum = 0;
                    } else {
                        this.form.my_score = rs.data.my_score;
                        this.form.my_score_sum = rs.data.my_score_sum;
                        this.checkMySum = rs.data.my_score_sum;
                    }

                    if (!rs.data.re_score) {
                        this.form.re_score = ['', '', '', '', ''];
                        this.form.re_score_sum = 0;
                    } else {
                        this.form.re_score = rs.data.re_score;
                        this.form.re_score_sum = rs.data.re_score_sum;
                        this.checkReSum = rs.data.re_score_sum;
                    }
                });
            },
            submitForm() {
                this.$refs['form'].validate((valid) => {
                    if (valid) {
                        let data = this.form;
                        data.account_id = this.userId;
                        data.edit = this.edit;
                        saveKpi(data).then((rs) => {
                            this.$message.success('保存成功');
                        });
                    } else {
                        this.$message.error('表单未完成,无法提交')
                        return false;
                    }
                });
            },
            appendScore(name) {
                let sum = name + '_sum';
                this.form[sum] = 0;
                const limit = [30, 30, 15, 10, 15]
                for (let i = 0; i <= 4; i++) {
                    let score = Number(this.form[name][i]);
                    if (score > limit[i]) {
                        this.form[name][i] = 0;
                        this.$message.error('超过最大值');
                    } else {
                        this.form[sum] += score;
                    }

                }
            }
        }
    }
</script>