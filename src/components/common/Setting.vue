<template>
    <div class="icons-container">
        <el-tabs type="border-card" v-model="setting">
            <el-tab-pane label="环境变量" name="env">
                <el-container style="max-width:1000px;">
                    <el-aside width="150px">
                        <div class="menu-toggle">
                            <span style="float:left; color:#000; font-size:16px; margin-left:10px;">环境列表</span>
                            <el-button type="primary" icon="el-icon-plus" placeHolder="添加环境变量" size="small" @click="addEnv"></el-button>
                        </div>
                        <template v-for="(item, index) in tags">
                            <el-row>
                                <el-tooltip content="私有环境"><el-tag v-if="item.private" :type="getTagType(index, '')" @click="editTag(item.id, index)" closable @close="handleClose(item.id)" title="私有">{{item.name}}</el-tag></el-tooltip>
                                <el-tooltip content="公共环境"><el-tag v-if="!item.private" :type="getTagType(index,'')" @click="editTag(item.id, index)" closable @close="handleClose(item.id)">{{item.name}}</el-tag></el-tooltip>
                            </el-row>
                        </template>
                    </el-aside>
                    <el-main>
                        <el-form ref="form" :model="form" :rules="rules" label-width="80px">
                            <el-form-item label="环境名称" prop="name">
                                <el-input v-model="form.name"></el-input>
                            </el-form-item>
                            <el-form-item label="环境域名" prop="domain">
                                <el-row>
                                    <el-input v-model="form.domain">
                                        <el-select v-model="form.url_prefix" slot="prepend" style="width: 100px">
                                            <el-option label="http://" value="http://"></el-option>
                                            <el-option label="https://" value="https://"></el-option>
                                        </el-select>
                                    </el-input>
                                </el-row>
                            </el-form-item>
                            <el-form-item label="Header">
                                <div v-for="(item, index) in form.global_header" :key="index">
                                <el-row style="margin-bottom: 5px" :gutter="5">
                                    <el-col :span="6">
                                        <el-input v-model="item.key" placeHolder="请输入header名称" prop="header_key"></el-input>
                                    </el-col>
                                    <el-col :span="16">
                                        <el-input v-model="item.value" placeHolder="请输入header值" prop="header_value"></el-input>
                                    </el-col>
                                    <template v-if="index == 0">
                                    <el-col :span="1">
                                        <i class="el-icon-plus" @click="addField('global_header')"></i>
                                    </el-col>
                                    </template>
                                    <template v-else>
                                        <el-col :span="1">
                                            <i class="el-icon-delete" @click="removeField('global_header', index)"></i>
                                        </el-col>
                                    </template>
                                </el-row>
                                </div>
                            </el-form-item>
                            <el-form-item label="Cookie">
                                <div v-for="(item, index) in form.global_cookie" :key="index">
                                <el-row style="margin-bottom: 5px" :gutter="5">
                                    <el-col :span="6">
                                        <el-input v-model="item.key" placeHolder="请输入cookie名称" prop="cookie_key"></el-input>
                                    </el-col>
                                    <el-col :span="16">
                                        <el-input v-model="item.value" placeHolder="请输入cookie值" prop="cookie_value"></el-input>
                                    </el-col>
                                    <template v-if="index == 0">
                                        <el-col :span="1">
                                            <i class="el-icon-plus" @click="addField('global_cookie')"></i>
                                        </el-col>
                                    </template>
                                    <template v-else>
                                        <el-col :span="1">
                                            <i class="el-icon-delete" @click="removeField('global_cookie', index)"></i>
                                        </el-col>
                                    </template>
                                </el-row>
                                </div>
                            </el-form-item>
                            <el-form-item label="">
                                <el-row>
                                    <el-col :span="12">
                                        <el-checkbox label="默认" v-model="form.default"></el-checkbox>
                                    </el-col>
                                    <el-col :span="1"></el-col>
                                    <el-col :span="11">
                                        <el-checkbox label="私有" v-model="form.private"></el-checkbox>
                                    </el-col>
                                </el-row>
                            </el-form-item>
                            <el-form-item>
                                <el-button type="primary" icon="el-icon-document-add" native-type="submit"
                                           @click.native.prevent="handleSave('form')">{{ this.editId ? '更新' : '保存' }}
                                </el-button>
                            </el-form-item>
                        </el-form>
                    </el-main>
                </el-container>
            </el-tab-pane>
            <el-tab-pane label="会员列表" name="member">
                <Member></Member>
            </el-tab-pane>
            <el-tab-pane label="接口生成" name="api">
                <Interface></Interface>
            </el-tab-pane>
            <el-tab-pane label="项目设置" name="project">
                <ProjectSet></ProjectSet>
            </el-tab-pane>
        </el-tabs>
    </div>
</template>
<script>
    import {getProjectEnv, saveProjectEnv, getEnvDetail, updateEnv, delEnv} from '@/api/env';
    import Member from '@/components/common/Member';
    import Interface from '@/components/common/Interface';
    import ProjectSet from '@/components/common/ProjectSet';
    export default {
        name: 'Sets',
        data() {
            return {
                'setting': sessionStorage.getItem('setting') ? sessionStorage.getItem('setting') : 'env',
                tags: [],
                currentTagSelect : '',
                form: {
                    'url_prefix': 'http://',
                    'name': '',
                    'domain': '',
                    'sort': 0,
                    'global_header': [{'key': '', 'value': ''}],
                    'global_cookie': [{'key': '', 'value': ''}],
                    'private': true
                },
                rules: {
                    name: [{
                        required: true,
                        message: '环境名称不能为空',
                        trigger: 'blur'
                    }],
                    domain: [{
                        required: true,
                        message: '域名不能为空',
                        trigger: 'blur'
                    }]
                },
                editId: 0,
                creatureKey: 0
            }
        },
        props: ['projectId', 'accountId'],
        created() {
            this.init()
        },
        components: {Member, Interface, ProjectSet},
        methods: {
            init() {
                this.getTag()
            },
            handleSave(formName) {
                this.$refs[formName].validate(valid => {
                    if (valid) {
                        let data = {...this.form}
                        data.project_id = this.projectId
                        data.account_id = this.accountId
                        data.default = (data.default == true) ? 1: 0;
                        data.private = (data.private == true) ? 1: 0;
                        data.global_header = JSON.stringify(data.global_header);
                        data.global_cookie = JSON.stringify(data.global_cookie);
                        if (this.editId == 0) {
                            saveProjectEnv(data).then((rs) => {
                                this.$message.success('保存成功');
                                this.getTag();
                                this.addEnv();
                            })
                        } else {
                            updateEnv(data).then((rs) => {
                                this.$message.success('保存成功');
                                this.getTag();
                            })
                        }
                    }
                });
            },
            getTagType(index, defaultValue) {
               if (index ==this.currentTagSelect && typeof(this.currentTagSelect) == 'number') {
                   return 'warning';
               } else {
                   return defaultValue;
               }
            },
            getTag() {
                getProjectEnv(this.projectId).then((rs) => {
                    this.tags = rs.data;
                })
                this.currentTagSelect = '';
            },
            editTag(id, index){
                this.currentTagSelect = index;
                this.$refs.form.resetFields();
                getEnvDetail({id: id}).then((rs) => {
                    this.editId = id;
                    this.form = rs.data;
                    if (!this.form.global_header) {
                        this.$set(this.form, 'global_header', [{'key': '', 'value': ''}]);
                    } else {
                        this.form.global_header = JSON.parse(rs.data.global_header);
                    }

                    if (!this.form.global_cookie) {
                        this.$set(this.form, 'global_cookie', [{'key': '', 'value': ''}]);
                    } else {
                        this.form.global_cookie = JSON.parse(rs.data.global_cookie);
                    }

                    this.form.private = (rs.data.private > 0) ? true : false;
                    this.form.default = (rs.data.default > 0) ? true : false;
                });
            },
            addField(creature) {
                this.form[creature].push({
                    'key': '',
                    'value': ''
                });
            },
            removeField(creature, index) {
                this.form[creature].splice(index, 1)
            },
            addEnv(){
                this.editId = 0
                this.form = {'url_prefix': 'http://'};
                if (!this.form.global_header) {
                    this.$set(this.form, 'global_header', [{'key': '', 'value': ''}]);
                }

                if (!this.form.global_cookie) {
                    this.$set(this.form, 'global_cookie', [{'key': '', 'value': ''}]);
                }
                this.form.private = true;
                //this.$refs['form'].resetFields()
            },
            handleClose(id) {
                this.$confirm('确定删除该环境吗?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    delEnv({id: id}).then((rs) => {
                        this.$message.success('删除成功');
                        this.getTag()
                    })
                })
            }
        }
    }

</script>
<style scoped>
    .el-col {
        min-height: 1px;
    }

    .menu-toggle {
        background: #eceef1;
        text-align: right;
        color: white;
        height: 40px;
        line-height: 40px;
        font-size: 13px;
    }

    .el-tag {
        margin:10px;
        cursor: pointer;
    }

    .el-icon-plus {
        margin-left: 5px;
        cursor: pointer;
    }

    .el-icon-delete {
        cursor: pointer;
    }

    .el-icon-circle-plus-outline {
        cursor: pointer;
    }

    .el-dialog__body {
        margin-top: 0px;
        padding-top: 0px
    }

    .el-menu-item, .el-submenu__title {
        background-color: #ccc;
        height: 10px;
        line-height: 10px;
        width: 10px;
    }

    .el-menu-item:hover, .el-submenu .el-menu-item:hover, .el-submenu__title:hover {
        background-color: #7ed2df;
        height: 10px;
        line-height: 10px
    }
</style>
