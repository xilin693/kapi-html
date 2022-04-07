<template>
    <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="导出类型" prop="type">
            <el-select v-model="form.type">
                <el-option label="Kapi json" value="1"></el-option>
            </el-select>
        </el-form-item>
        <el-form-item label="项目名称" prop="project_id">
            <el-select v-model="form.project_id">
                <el-option v-for="item in projects" :key="item.id" :label="item.name"
                           :value="item.id"></el-option>
            </el-select>
        </el-form-item>
        <el-form-item>
            <el-button type="primary" icon="el-icon-document-add" native-type="submit"
                       @click.native.prevent="handleSave('form')" :loading="loading">导出
            </el-button>
        </el-form-item>
    </el-form>
</template>

<script>
    import FileSaver from 'file-saver';
    import {getOwnerProject, importProject, exportProject} from '@/api/project';
    import {delFile} from '@/api/general';
    export default {
        data() {
            return {
                form: {
                    'type': '1',
                    'project_id': 0
                },
                rules: {
                    type: [{
                        required: true,
                        message: '导出类型不能为空',
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
                        exportProject(data).then((rs) => {
                            this.exportJson(JSON.stringify(rs.data));
                            this.loading = false;
                        }).catch(() => {
                            this.loading = false;
                        })
                    }
                });
            },
            exportJson(data) {
                // 将json转换成字符串
                const blob = new Blob([data], {type: ''})
                FileSaver.saveAs(blob, 'project.json')
            },
        }
    }
</script>
