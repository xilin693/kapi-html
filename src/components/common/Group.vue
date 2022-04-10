<template>
    <el-container style="width:700px;">
        <el-main>
            <el-button type="primary" icon="el-icon-plus" placeHolder="添加项目组" size="small" @click="addTag"></el-button>
            <template v-for="(item, index) in tags">
                <el-tag @click="editTag(item)" closable @close="handleClose(item.id)">{{item.name}}</el-tag>
            </template>
            <el-form ref="form" :model="form" :rules="rules" label-width="120px">
                <el-form-item label="项目组名称" prop="name">
                    <el-input v-model="form.name" style="width:200px"></el-input>
                </el-form-item>
                <template v-if="editId > 0">
                <el-form-item label="子项目">
                    <template v-for="(item2, index2) in subItem">
                        <el-tag closable @close="delSubItem(item2.id)">{{item2.name}}</el-tag>
                    </template>
                </el-form-item>
                </template>
                <el-form-item label="项目经理" prop="account_id">
                    <el-select v-model="form.leader_id" filterable>
                        <el-option v-for="item in accounts" :key="item.id" :label="item.username"
                                   :value="item.id">
                            <span style="float: left">{{ item.username }}</span>
                            <span style="float: right; color: #8492a6; font-size: 13px">{{ item.realname }}</span>
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" icon="el-icon-document-add" native-type="submit"
                               @click.native.prevent="handleSave('form')">{{ this.editId ? '更新' : '保存' }}
                    </el-button>
                </el-form-item>
            </el-form>
        </el-main>
    </el-container>
</template>

<script>
    import {getNameList} from '@/api/user';
    import {getNavGroup, saveProjectGroup, updateProjectGroup, delProjectGroup, getGroupProject} from '@/api/project';

    export default {
        name: 'Setting',
        data() {
            return {
                subItem:[],
                tags: [],
                form: {
                    'name': '',
                    'leader_id': ''
                },
                rules: {
                    name: [{
                        required: true,
                        message: '项目组名称不能为空',
                        trigger: 'blur'
                    }]
                },
                editId: 0,
                accounts: []
            }
        },
        props: ['projectId'],
        created() {
            this.init()
        },
        methods: {
            init() {
                getNameList({'project_id': 0}).then((rs) => {
                    this.accounts = rs.data;
                });
                this.getTag()
            },
            handleSave(formName) {
                this.$refs[formName].validate(valid => {
                    if (valid) {
                        let data = {...this.form}
                        if (this.editId == 0) {
                            saveProjectGroup(data).then((rs) => {
                                this.$message.success('保存成功');
                                this.getTag();
                            })
                        } else {
                            data.id = this.editId;
                            updateProjectGroup(data).then((rs) => {
                                this.$message.success('更新成功')
                                this.getTag();
                            })
                        }
                    }
                });
            },
            getTag() {
                getNavGroup(this.projectId).then((rs) => {
                    this.tags = rs.data;
                })
            },
            editTag(item) {
                this.editId = item.id;
                this.form.name = item.name;
                this.getSubItem(item.id);
                this.form.leader_id = item.leader_id ? item.leader_id : '';
            },
            onInput() {
                this.$forceUpdate()
            },
            addTag() {
                this.editId = 0;
                this.form.name = '';
                this.subItem=[];
                this.form.leader_id = '';
            },
            getSubItem(id) {
                getGroupProject({ id: id }).then(rs => {
                    this.subItem = rs.data
                })
            },
            handleClose(id) {
                this.$confirm('确定删除该项目组吗?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    delProjectGroup({id: id}).then((rs) => {
                        this.$message.success('删除成功');
                        this.getTag()
                    })
                })
            },
            delSubItem(id) {
                this.$confirm('确定删除该项目吗?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    delProjectGroup({id: id}).then((rs) => {
                        this.$message.success('删除成功');
                        this.getSubItem(this.editId)
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
        margin: 10px;
        cursor: pointer;
    }

    .el-row {
        max-width: 600px;
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
