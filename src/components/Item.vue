<template>
    <div class="icons-container" style="width: 500px">
        <el-main>
            <el-form :model="form" :rules="rules" ref="form" label-width="100px" class="demo-ruleForm">
                <el-form-item label="项目名称" prop="name">
                    <el-input v-model="form.name"></el-input>
                </el-form-item>

                <el-form-item label="所属分组" prop="pid">
                    <el-select v-model="form.pid" style="width:100%">
                        <el-option v-for="(item, index) in projects" :key="item.name" :label="item.name"
                                   :value="item.id"></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" icon="el-icon-document-add" native-type="submit"
                               @click.native.prevent="handleSave('form')">保存
                    </el-button>
                </el-form-item>
            </el-form>
        </el-main>
    </div>
</template>
<script>
    import {getAllGroup, saveProject} from '@/api/project'

    export default {
        name: 'item',
        data() {
            return {
                form: {
                    name: '',
                    pid: ''
                },
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
                }
            }
        },
        created() {
            this.init()
        },
        methods: {
            init() {
                getAllGroup().then((rs) => {
                    this.projects = rs.data
                })
            },
            handleSave(formName) {
                this.$refs[formName].validate(valid => {
                    if (valid) {
                        let params = {...this.form};
                        saveProject(params).then((rs) => {
                            this.$message.success('添加项目成功');
                        })
                    }
                })
            }
        }
    }
</script>
