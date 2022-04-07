<template>
    <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="导入类型" prop="type">
            <el-select v-model="form.type">
                <el-option label="Kapi json" value="1"></el-option>
                <el-option label="Yapi json" value="2"></el-option>
                <el-option label="Postman json" value="3"></el-option>
            </el-select>
        </el-form-item>
        <el-form-item label="项目名称" prop="project_id">
            <el-select v-model="form.project_id">
                <el-option v-for="item in projects" :key="item.id" :label="item.name"
                           :value="item.id"></el-option>
            </el-select>
            <span style="padding-left:10px; color: #ff0000">建议使用空项目导入,导入会删除选中项目所有接口</span>
        </el-form-item>
        <el-form-item label="选择文件">
            <el-upload
                    class="upload-demo"
                    style="width:300px"
                    action="api/files"
                    name="userfile"
                    :on-remove="handleRemove"
                    :before-remove="beforeRemove"
                    :limit="1"
                    :on-error="handleError"
                    :on-success="handleSuccess"
                    :on-exceed="handleExceed">
                <el-button size="small" type="success">点击上传</el-button>
                <span slot="tip" class="el-upload__tip" style="margin-left: 10px; color: #ff0000">只能上传json文件，且不超过8M</span>
            </el-upload>
        </el-form-item>
        <el-form-item>
            <el-button type="primary" icon="el-icon-document-add" native-type="submit"
                       @click.native.prevent="handleSave('form')" :loading="loading">导入
            </el-button>
        </el-form-item>
    </el-form>
</template>

<script>
    import {getOwnerProject, importProject} from '@/api/project';
    import {delFile} from '@/api/general';
    export default {
        data() {
            return {
                form: {
                    'type': '1',
                    'project_id': 0,
                    'filename': ''
                },
                rules: {
                    type: [{
                        required: true,
                        message: '导入类型不能为空',
                        trigger: 'blur'
                    }],
                    project_id: [{
                        required: true,
                        message: '项目名称不能为空',
                        trigger: 'blur'
                    }]
                },
                'loading': false,
                projects: []
            }
        },
        created() {
            this.init();
        },
        methods: {
            init() {
                getOwnerProject().then(res => {
                    this.projects = res.data;
                    this.form.project_id = this.projects[0].id;
                })
            },
            handleSave(formName) {
                this.loading = true;
                this.$refs[formName].validate(valid => {
                    if (valid) {
                        let data = {...this.form};
                        delete(data.userfile);
                        importProject(data).then(() => {
                            this.$message.success('导入成功');
                            this.handleRemove();
                            this.loading = false;
                        }).catch(() => {
                            this.loading = false
                        })
                    }
                });
            },
            handleRemove() {
                delFile({'file': this.form.filename}).then(() => {
                   // this.$message.success('文件删除成功');
                })
            },
            handleExceed() {
                this.$message.warning(`当前限制只能上传 1 个文件,请先删除已上传文件`);
            },
            handleSuccess(rs) {
              this.form.filename  = rs.filename;
            },
            beforeRemove(file) {
                return this.$confirm(`确定移除 ${ file.name }？`);
            },
            handleError(error) {
                const rs = JSON.parse(error.message);
                this.$message.warning(rs.msg);
            }
        }
    }
</script>
