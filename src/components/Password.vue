<template>
    <div class="icons-container" style="width: 500px">
        <el-main>
            <el-form :model="form" :rules="rules" ref="form" label-width="100px" class="demo-ruleForm">
                <el-form-item label="旧密码" prop="old_password">
                    <el-input v-model="form.old_password" type="password" auto-complete="off"></el-input>
                </el-form-item>
                <el-form-item label="新密码" prop="password">
                    <el-input v-model="form.password" type="password" auto-complete="off"></el-input>
                </el-form-item>
                <el-form-item label="确认密码" prop="password2">
                    <el-input v-model="form.password2" type="password" auto-complete="off"></el-input>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" icon="el-icon-document-add" native-type="submit"
                               @click.native.prevent="handleSave('form')">更新密码
                    </el-button>
                </el-form-item>
            </el-form>
        </el-main>
    </div>
</template>
<script>
    import {updatePassword} from '@/api/user'

    export default {
        name: 'password',
        data() {
            const validatePassword2 = (rule, value, callback) => {
                if (value === '') {
                    callback(new Error('请输入确认密码'));
                } else if (value !== this.form.password) {
                    callback(new Error('两次输入密码不一致!'));
                } else {
                    callback();
                }
            };
            return {
                form: {
                    old_password: '',
                    password: '',
                    password2: '',
                },
                projects: {},
                rules: {
                    old_password: [{
                        required: true,
                        message: '请输入旧密码',
                        trigger: 'blur',
                    }],
                    password: [{
                        required: true,
                        message: '密码长度不能小于6',
                        min: 6,
                        trigger: 'blur',
                    }],
                    password2: [{
                        required: true,
                        trigger: 'blur',
                        validator: validatePassword2
                    }]
                }
            }
        },
        created() {
        },
        methods: {
            handleSave(formName) {
                this.$refs[formName].validate(valid => {
                    if (valid) {
                        let params = {...this.form};
                        updatePassword(params).then((rs) => {
                            this.$message.success('修改密码成功');
                        })
                    }
                })
            }
        }
    }
</script>
