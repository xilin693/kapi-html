<template>
    <div class="icons-container" style="width: 500px">
        <el-main>
            <el-form :model="form" :rules="rules" ref="form" label-width="150px" class="demo-ruleForm">
                <el-form-item label="项目名称" prop="name">
                    <el-input v-model="form.name"></el-input>
                </el-form-item>

                <el-form-item label="所属分组" prop="pid">
                    <el-select v-model="form.pid" style="width:100%">
                        <el-option v-for="(item, index) in projects" :key="item.name" :label="item.name"
                                   :value="item.id"></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="允许post json" prop="post_use_json">
                    <el-checkbox label="" v-model="form.post_use_json" value="1"></el-checkbox>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" icon="el-icon-document-add" native-type="submit"
                               @click.native.prevent="handleSave('form')" :disabled="disabled">{{tag}}
                    </el-button>
                </el-form-item>
            </el-form>
        </el-main>
    </div>
</template>
<script>
    import {userinfo} from '@/api/user';
    import {getAllGroup, saveProject, getCurrentProject, updateProjectGroup, getCurrentMember} from '@/api/project'

    export default {
        name: 'item',
        data() {
            return {
                form: {
                    name: '',
                    pid: '',
                    post_use_json: 0
                },
                tag: '添加',
                projects: {},
                rules: {
                    name: [{
                        required: true,
                        message: '请输入项目名称',
                        trigger: 'blur',
                    }],
                    pid: [{
                        required: true,
                        message: '请选择分组',
                        trigger: 'blur',
                    }]
                },
                disabled: false
            }
        },
        created() {
            this.init()
        },
        methods: {
            init() {
                if (this.$route.params.id > 0) {
                  this.tag = '更新'
                  userinfo().then((rs) => {
                    this.userInfo = rs.data;
                    getCurrentMember({'account_id': this.userInfo.id, 'project_id': this.$route.params.id}).then((rs2) => {
                      this.member = rs2.data;
                      if (this.member.group !=1 && this.userInfo.id !=1) {
                        this.disabled = "disabled";
                      }
                    })
                  })

                  getCurrentProject(this.$route.params.id).then((rs) => {
                    this.form.name = rs.data.name;
                    this.form.pid = rs.data.pid;
                    this.form.post_use_json = rs.data.post_use_json ? true : false;
                  })
                }

                getAllGroup().then((rs) => {
                    this.projects = rs.data
                })
            },
            handleSave(formName) {
                this.$refs[formName].validate(valid => {
                    if (valid) {
                        let params = {...this.form};
                        params.id = this.$route.params.id;
                        params.post_use_json = (params.post_use_json == true) ? 1: 0;
                        if (params.id > 0) {
                          updateProjectGroup(params).then((rs) => {
                            parent.document.getElementById('pn').innerHTML = '- ' + this.form.name;
                            this.$message.success('更新项目成功');
                          })
                        } else {
                          saveProject(params).then((rs) => {
                            this.$message.success('添加项目成功');
                            location.reload();
                          })
                        }

                    }
                })
            }
        }
    }
</script>
