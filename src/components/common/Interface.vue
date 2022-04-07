<template>
    <div>
        <el-form :model="form" ref="form" label-position="top" :rules="rules">
            <el-form-item label="数据库设置">
                <el-row :gutter="5">
                    <el-col :span="10">
                        <el-form-item prop="db">
                            <el-input v-model="form.db" placeHolder="请输入库名"></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="10">
                        <el-form-item prop="table">
                            <el-input v-model="form.table" placeHolder="请输入表名"></el-input>
                        </el-form-item>
                    </el-col>
                </el-row>
            </el-form-item>
            <el-form-item label="接口设置">
                <el-row :gutter="5">
                    <el-col :span="10">
                        <el-form-item prop="category">
                            <el-input v-model="form.category" placeHolder="请输入分类名称"></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="10">
                        <el-form-item prop="rest">
                            <el-input v-model="form.rest" placeHolder="请输入rest资源名称"></el-input>
                        </el-form-item>
                    </el-col>
                </el-row>
            </el-form-item>
            <el-form-item label="">
                <el-checkbox label="Post Json" v-model="form.post_type" value="1"></el-checkbox>
            </el-form-item>
            <el-form-item>
                <el-button type="primary" @click.native="handleImport">导入接口</el-button>
            </el-form-item>
        </el-form>
        <el-form :model="formInterface" v-if="interface">
            <el-form-item>
                <el-row :gutter="5">
                    <el-col :span="2">
                        <el-switch
                                v-model="formInterface.select"
                                active-value="1"
                                inactive-value="0">
                        </el-switch>查询
                    </el-col>
                    <el-col :span="5">
                        <el-input v-model="formInterface.select_text" placeHolder="接口名称"></el-input>
                    </el-col>
                    <el-col :span="5">
                        <el-input v-model="formInterface.select_url" placeHolder="rest网址"></el-input>
                    </el-col>
                    <el-col :span="10">
                        <el-input v-model="formInterface.query_data" placeHolder="查询参数"></el-input>
                    </el-col>
                </el-row>
            </el-form-item>
            <el-form-item>
                <el-row :gutter="5">
                    <el-col :span="2">
                        <el-switch
                                v-model="formInterface.add"
                                active-value="1"
                                inactive-value="0">
                        </el-switch>添加
                    </el-col>
                    <el-col :span="5">
                        <el-input v-model="formInterface.add_text" placeHolder="接口名称"></el-input>
                    </el-col>
                    <el-col :span="5">
                        <el-input v-model="formInterface.add_url" placeHolder="rest网址"></el-input>
                    </el-col>
                    <template v-if="form.post_type == true">
                        <el-col :span="10">
                            <el-input v-model="formInterface.post_data" type="textarea" autosize
                                      placeHolder="put内容"></el-input>
                        </el-col>
                    </template>
                    <template v-else>
                        <el-col :span="10">
                            <el-input v-model="formInterface.form_data" type="textarea" autosize
                                      placeHolder="post内容"></el-input>
                        </el-col>
                    </template>
                </el-row>
                <template v-if="form.post_type == true">
                <el-row>
                    <el-col :span="10" :offset="12">
                        <el-input v-model="formInterface.post_doc" type="textarea" autosize
                                  placeHolder="put文档"></el-input>
                    </el-col>
                </el-row>
                </template>
            </el-form-item>
            <el-form-item>
                <el-row :gutter="5">
                    <el-col :span="2">
                        <el-switch
                                v-model="formInterface.edit"
                                active-value="1"
                                inactive-value="0">
                        </el-switch>编辑
                    </el-col>
                    <el-col :span="5">
                        <el-input v-model="formInterface.edit_text" placeHolder="接口名称"></el-input>
                    </el-col>
                    <el-col :span="5">
                        <el-input v-model="formInterface.edit_url" placeHolder="rest网址"></el-input>
                    </el-col>
                    <el-col :span="10">
                        <el-input v-model="formInterface.put_data" type="textarea" autosize
                                  placeHolder="put内容"></el-input>
                    </el-col>
                </el-row>
                <el-row>
                    <el-col :span="10" :offset="12">
                        <el-input v-model="formInterface.put_doc" type="textarea" autosize
                                  placeHolder="put文档"></el-input>
                    </el-col>
                </el-row>
            </el-form-item>
            <el-form-item>
                <el-row :gutter="5">
                    <el-col :span="2">
                        <el-switch
                                v-model="formInterface.delete"
                                active-value="1"
                                inactive-value="0">
                        </el-switch>删除
                    </el-col>
                    <el-col :span="5">
                        <el-input v-model="formInterface.delete_text" placeHolder="接口名称"></el-input>
                    </el-col>
                    <el-col :span="5">
                        <el-input v-model="formInterface.delete_url" placeHolder="rest网址"></el-input>
                    </el-col>
                </el-row>
            </el-form-item>
            <el-form-item>
                <el-row :gutter="5">
                    <el-col :span="2">
                        <el-switch
                                v-model="formInterface.detail"
                                active-value="1"
                                inactive-value="0">
                        </el-switch>详情
                    </el-col>
                    <el-col :span="5">
                        <el-input v-model="formInterface.detail_text" placeHolder="接口名称"></el-input>
                    </el-col>
                    <el-col :span="5">
                        <el-input v-model="formInterface.detail_url" placeHolder="rest网址"></el-input>
                    </el-col>

                    <el-col :span="10">
                        <el-input v-model="formInterface.return_data" type="textarea" autosize
                                  placeHolder="详情注释"></el-input>
                    </el-col>
                </el-row>
            </el-form-item>
            <el-form-item>
                <el-row :gutter="5">
                    <el-col :span="2">
                        <el-switch
                                v-model="formInterface.status"
                                active-value="1"
                                inactive-value="0">
                        </el-switch>设置状态
                    </el-col>
                    <el-col :span="3">
                        <el-input v-model="formInterface.status_text" placeHolder="接口名称"></el-input>
                    </el-col>
                    <el-col :span="4">
                        <el-input v-model="formInterface.status_url" placeHolder="rest网址"></el-input>
                    </el-col>
                    <el-col :span="6">
                        <el-input v-model="formInterface.status_put_data" type="textarea" autosize
                                  placeHolder="put内容"></el-input>
                    </el-col>
                </el-row>
            </el-form-item>
            <el-form-item>
                <el-button type="success" @click="handleSave">保存接口</el-button>
            </el-form-item>
        </el-form>
        <el-divider>PHP接口辅助</el-divider>
        <el-row>
            <el-input v-model="php_rule" placeHolder="校验规则" autosize type="textarea"></el-input>
        </el-row>
    </div>
</template>
<script>
    import {importRest, saveRest} from "@/api/general";

    export default {
        data() {
            return {
                form: {},
                formInterface: {
                    'add': '1',
                    'select': '1',
                    'edit': '1',
                    'delete': '1',
                    'detail': '0',
                    'status': '0',
                    'select_text': '',
                    'add_text': '',
                    'edit_text': '',
                    'delete_text': '',
                    'detail_text': '',
                    'status_text': '',
                    'select_url': '',
                    'add_url': '',
                    'edit_url': '',
                    'delete_url': '',
                    'detail_url': '',
                    'status_url': '',
                    'query_data': '',
                    'form_data': '',
                    'post_data': '',
                    'post_doc': '',
                    'put_data': '',
                    'put_doc': '',
                    'return_data': '',
                    'status_put_data': '',
                },
                php_rule: '',
                interface: false,
                rules: {
                    db: [{
                        required: true,
                        message: '请输入数据库名',
                        trigger: 'blur',
                    }],
                    table: [{
                        required: true,
                        message: '请输入表名',
                        trigger: 'blur',
                    }],
                    category: [{
                        required: true,
                        message: '请输入分类名称',
                        trigger: 'blur',
                    }],
                    rest: [{
                        required: true,
                        message: '请输入rest资源名称',
                        trigger: 'blur',
                    }]
                },
            }
        },
        created() {
        },
        methods: {
            handleImport() {
                this.$refs['form'].validate(valid => {
                    if (valid) {
                        let params = {...this.form};
                        console.log(params);
                        importRest(params).then((rs) => {
                            this.formInterface.category = this.form.category;
                            this.formInterface.header_data = JSON.stringify(rs.data.header_data);
                            this.formInterface.form_data = JSON.stringify(rs.data.form_data);
                            this.formInterface.query_data = JSON.stringify(rs.data.query_data);
                            this.formInterface.post_type = this.form.post_type ? 1 : 0;
                            this.formInterface.post_data = rs.data.post_data;
                            this.formInterface.post_doc = JSON.stringify(rs.data.post_doc);
                            this.formInterface.put_data = rs.data.put_data;
                            this.formInterface.put_doc = JSON.stringify(rs.data.put_doc);
                            this.formInterface.return_data = JSON.stringify(rs.data.return_data);
                            this.formInterface.status_text = '更新指定记录状态';
                            this.formInterface.detail_text = '获取指定记录详情';
                            this.formInterface.delete_text = '删除指定记录';
                            this.formInterface.edit_text = '更新指定记录';
                            this.formInterface.add_text = '新增记录';
                            this.formInterface.select_text = '获取所有记录';
                            this.formInterface.select_url = rs.data.select_url;
                            this.formInterface.add_url = rs.data.add_url;
                            this.formInterface.edit_url = rs.data.edit_url;
                            this.formInterface.delete_url = rs.data.delete_url;
                            this.formInterface.detail_url = rs.data.detail_url;
                            this.formInterface.status_url = rs.data.status_url;
                            this.formInterface.project_id = this.$route.params.id;
                            this.formInterface.status_put_data = rs.data.status_put_data;
                            this.php_rule = rs.data.php_rule;
                        });
                        this.interface = true;
                    }
                });
            },
            handleSave() {
                let params2 = {...this.formInterface};
                params2.category = this.form.category;
                params2.rest = this.form.rest;
                saveRest(params2).then((rs) => {
                    this.$message.success('接口保存成功');
                    sessionStorage.setItem('setting', 'api');
                    location.reload();
                })
            }
        }
    }
</script>
