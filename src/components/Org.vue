<template>
    <div class="icon-container" v-loading="loading">
        <el-row :gutter="5" id="card">
            <el-col :span="1">
                <el-card shadow="always" style="background-color: #61169ACC">
                    规划中
                </el-card>
            </el-col>
            <el-col :span="1">
                <el-card shadow="always" style="background-color: #1E95D8CC">
                    开发中
                </el-card>
            </el-col>
            <el-col :span="1">
                <el-card shadow="always" style="background-color: #1EB115CC">
                    已完成
                </el-card>
            </el-col>
            <el-col :span="1">
                <el-card shadow="always" style="background-color: #D9534FCC">
                    维护中
                </el-card>
            </el-col>
            <el-col :span="1">
                <el-card shadow="always" style="background-color: #F1BC27CC">
                    已暂停
                </el-card>
            </el-col>
        </el-row>
        <organization-chart :datasource="ds" @node-click="handleClick">
            <template slot-scope="{ nodeData }">
                <div class="node">
                    <div class="title" :style="getBackground(nodeData.status)"><i class="fa fa-users symbol"></i>
                        {{nodeData.name}}
                    </div>
                    <div class="content" :style="getBorder(nodeData.status)">{{nodeData.title}}
                        <template v-if="checkId(nodeData.id)">
                            <el-progress :percentage="nodeData.progress" :color="customColors"></el-progress>
                        </template>
                    </div>
                </div>
            </template>
        </organization-chart>
        <el-dialog title="绩效复评" :visible.sync="evalVisible" width="1250px" v-if="evalVisible">
            <el-divider></el-divider>
            <Exam edit="re" :userId="userId" :realname="realname"></Exam>
        </el-dialog>
        <el-dialog :title="proTitle" :visible.sync="proVisible" width="500px">
            <el-form :model="proForm" ref="proForm">
                <el-form-item>
                    <div style="display: flex">
                        <el-button icon="el-icon-minus" @click="decrease('proForm')" size="mini"></el-button>
                        <el-progress :percentage="proForm.percentage" :color="customColors"
                                     style="margin: 10px; width: 400px"></el-progress>
                        <el-button icon="el-icon-plus" @click="increase('proForm')" size="mini"></el-button>
                    </div>
                </el-form-item>
                <el-form-item label="状态">
                    <el-select v-model="proForm.status" placeholder="请选择项目状态" style="width:50%;">
                        <el-option label="开发中" :value="0"></el-option>
                        <el-option label="已完成" :value="1"></el-option>
                        <el-option label="维护中" :value="2"></el-option>
                        <el-option label="规划中" :value="3"></el-option>
                        <el-option label="已暂停" :value="-1"></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="版本号" v-if="versionShow">
                    <el-input v-model="proForm.version" style="width:50%;"></el-input>
                </el-form-item>
                <div style="margin-top: 20px">
                    <el-button type="primary" @click="saveProgress">保存</el-button>
                    <el-button @click="proVisible=false">关闭</el-button>
                </div>
            </el-form>
        </el-dialog>
    </div>
</template>
<style>

    .orgchart {
        background-image: none;
    }

    .orgchart-container {
        min-height: 600px;
    }

    .orgchart .node .title {
        font-size: 14px;
    }

    .orgchart .node .content {
        height: auto;
        white-space: normal;
        font-size: 13px;
    }

    .onlyText {
        padding-right: 3px;
    }

    .onlyClick {
        padding-right: 3px;
        cursor: pointer;
        color: cadetblue;
    }

    #card .el-card__body {
        padding: 5px;
        font-size: 13px;
        width: 100px;
        color: #fff;
    }
</style>

<script>
    import {getProjectOrganize, getCurrentProject, updateProjectProgress} from '@/api/project';
    import {getKpi, updateKpi} from '@/api/kpi';
    import Exam from '@/components/common/Exam';
    import OrganizationChart from 'vue-organization-chart';
    import 'vue-organization-chart/dist/orgchart.css';

    export default {
        data() {
            return {
                loading: true,
                customBackground: {
                    '0': '#1E95D8CC', '1': '#1EB115CC', '2': '#D9534FCC', '3': '#61169ACC', '-1': '#F1BC27CC',
                    'x': '#38240FCC', 'y': '#38240FCC'
                },
                ds: {},
                customColors: [
                    {color: '#f42e28', percentage: 10},
                    {color: '#f44e28', percentage: 20},
                    {color: '#f46f28', percentage: 30},
                    {color: '#f49c28', percentage: 40},
                    {color: '#f4c328', percentage: 50},
                    {color: '#f4e928', percentage: 60},
                    {color: '#cbf428', percentage: 70},
                    {color: '#98f428', percentage: 80},
                    {color: '#6af428', percentage: 90},
                    {color: '#08f432', percentage: 100}
                ],
                proTitle: '项目进度',
                proForm: {
                    percentage: 0,
                    status: 0,
                    version:''
                },
                profile: {
                    my_score_sum: 0,
                    my_score: ['', '', '', '', '']
                },
                evalVisible: false,
                proVisible: false,
                ddVisible: false,
                progress_id: 0,
                progress_sub_id: 0,
                userId: 0,
                realname: '',
                versionShow: false,
                hasEval: true
            }
        },
        components: {
            OrganizationChart, Exam
        },
        created() {
            this.init();
        },
        methods: {
            init() {
                getProjectOrganize().then((rs) => {
                    this.ds = rs.data;
                    this.loading = false;
                })
            },
            getBackground(status) {
                let color = this.customBackground[status];
                return 'background-color:' + color;
            },
            getBorder(status) {
                let color = this.customBackground[status];
                if (status == 'y') {
                    return 'box-shadow: 0 5px 12px 0 rgba(0,0,0,.2); border: 3px solid ' + color;
                } else {
                    return 'border: 1px solid ' + color;
                }

            },
            handleClick(data) {
                if (typeof(data.id) != 'undefined') {
                    if (data.id.substr(0, 3) == 'cli') {
                        this.userId = data.id.substr(4);
                        this.realname = data.title;
                        getKpi({'id': this.userId}).then((rs) => {
                            if (!rs.data.my_score) {
                                this.$message.error('员工自评未填写');
                            } else {
                                this.profile = rs.data;
                                this.hasEval = true;
                                if (this.profile.re_score_sum > 0) {
                                    this.hasEval = false;
                                }
                                this.evalVisible = true;
                            }
                        });
                    }

                    if (data.id.substr(0, 3) == 'lea' || data.id.substr(0, 3) == 'ddu') {
                        this.progress_id = data.id.substr(4);
                        getCurrentProject(this.progress_id).then((rs) => {
                            this.proTitle = data.name + ' - 项目进度';
                            if (rs.data.pid == 0) {
                                this.versionShow = true;
                                this.proForm.version = rs.data.version;
                            } else {
                                this.versionShow = false;
                                this.proForm.version = '';
                            }
                            this.proForm.percentage = rs.data.progress;
                            this.proForm.status = Number(rs.data.status);
                            this.proVisible = true;
                        });
                    }
                }
            },
            checkId(id) {
                if (typeof(id) != 'undefined') {
                    let idPrefix = id.toString().substr(0, 2);
                    if (idPrefix == 'dd' || idPrefix == 'le') {
                        return true;
                    } else {
                        return false;
                    }
                }
            },
            saveProgress() {
                let data = {};
                data.id = this.progress_id;
                data.progress = this.proForm.percentage;
                data.version = this.proForm.version ? this.proForm.version: '1.0';
                data.status = this.proForm.status;
                updateProjectProgress(data).then((rs) => {
                    this.$message.success('进度已保存');
                    this.proVisible = false;
                })
            },
            increase(formName) {
                this[formName].percentage += 10;
                if (this[formName].percentage > 100) {
                    this[formName].percentage = 100;
                }
            },
            decrease(formName) {
                this[formName].percentage -= 10;
                if (this[formName].percentage < 0) {
                    this[formName].percentage = 0;
                }
            }
        }
    }
</script>