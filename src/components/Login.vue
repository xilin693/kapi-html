<template>
    <div class="login-container">
        <div class="title-container">
            <div class="title"><img src="logo.png" height="50px" /> </div>
        </div>
        <el-tabs v-model="activeName">
            <el-tab-pane label="登录" name="first">
                <el-form
                        ref="accountForm"
                        :model="accountForm"
                        :rules="rules"
                        label-position="left"
                        label-width="0px">
                    <el-form-item prop="username">
                        <el-input type="text" v-model="accountForm.username" auto-complete="off"
                                  placeholder="账号"></el-input>
                    </el-form-item>
                    <el-form-item prop="password">
                        <el-input type="password" v-model="accountForm.password" auto-complete="off"
                                  placeholder="密码"></el-input>
                    </el-form-item>
                    <el-form-item prop="captcha">
                        <el-input ref="captcha" type="text" v-model="accountForm.captcha" class="yzm"
                                  auto-complete="off"></el-input>
                        <img :src="list.img" alt="验证码" class="yzm_img" @click="init()"/>
                    </el-form-item>
                    <el-form-item style="width:100%;">
                        <el-button type="primary" style="width:100%;" native-type="submit"
                                   @click.native.prevent="handleLogin" :loading="loading">Sign in
                        </el-button>
                    </el-form-item>
                </el-form>
            </el-tab-pane>
            <el-tab-pane label="注册" name="second">
                <el-form
                        ref="regForm"
                        :model="regForm"
                        :rules="rules"
                        label-position="left"
                        label-width="0px">
                    <el-form-item prop="username">
                        <el-input type="text" v-model="regForm.username" auto-complete="off"
                                  placeholder="账号"></el-input>
                    </el-form-item>
                    <el-form-item prop="password">
                        <el-input type="password" v-model="regForm.password" auto-complete="off"
                                  placeholder="密码"></el-input>
                    </el-form-item>
                    <el-form-item prop="password2">
                        <el-input type="password" v-model="regForm.password2" auto-complete="off"
                                  placeholder="确认密码"></el-input>
                    </el-form-item>
                    <el-form-item prop="realname">
                        <el-input type="text" v-model="regForm.realname" auto-complete="off"
                                  placeholder="真实姓名"></el-input>
                    </el-form-item>
                    <el-form-item style="width:100%;">
                        <el-button type="success" style="width:100%;" native-type="submit"
                                   @click.native.prevent="handleReg" :loading="loading2">Sign up
                        </el-button>
                    </el-form-item>
                </el-form>
            </el-tab-pane>
        </el-tabs>
    </div>
</template>

<script>
    import {captcha, login, reg} from '@/api/login'
    import {setToken} from '@/utils/auth.js'

    export default {
        name: 'Login',
        data() {
            const validatePassword2 = (rule, value, callback) => {
                if (value === '') {
                    callback(new Error('请输入确认密码'));
                } else if (value !== this.regForm.password) {
                    callback(new Error('两次输入密码不一致!'));
                } else {
                    callback();
                }
            };
            return {
                activeName: 'first',
                loading: false,
                list: {},
                list2: {},
                accountForm: {
                    username: '',
                    password: '',
                    captcha: ''
                },
                regForm: {
                    username: '',
                    realname: '',
                    password: '',
                    password2: '',
                    captcha: ''
                },
                rules: {
                    username: [{
                        required: true,
                        message: '请输入账号',
                        trigger: 'blur',
                    }],
                    realname: [{
                        required: true,
                        message: '请输入真实姓名',
                        trigger: 'blur',
                    }],
                    password: [{
                        required: true,
                        message: '密码长度不能小于6',
                        min: 6,
                        trigger: 'blur',
                    }],
                    password2: [{
                        min: 6,
                        trigger: 'blur',
                        validator: validatePassword2
                    }],
                    captcha: [{
                        required: true,
                        trigger: 'blur',
                        message: '请输入验证码',
                    }]
                },
                loading: false,
                loading2: false
            }
        },
        created() {
            this.init()
        },
        methods: {
            init() {
                captcha().then(res => {
                    this.list = res.data
                    localStorage.setItem('code', res.data.code)
                })
            },
            handleLogin() {
                this.$refs['accountForm'].validate(valid => {
                    if (valid) {
                        this.loading = true
                        const loginParams = {
                            username: this.accountForm.username,
                            password: this.accountForm.password,
                            captcha: this.accountForm.captcha
                        }
                        login(loginParams)
                            .then(res => {
                                setToken(res.data.token)
                                this.$router.push({path: '/'})
                                this.loading = false
                            })
                            .catch(() => {
                                this.init()
                                this.loading = false
                            })
                    } else {
                        return false
                    }
                })
            },
            handleReg() {
                this.$refs['regForm'].validate(valid => {
                    if (valid) {
                        this.loading2 = true
                        const loginParams = {
                            username: this.regForm.username,
                            realname: this.regForm.realname,
                            password: this.regForm.password,
                            password2: this.regForm.password2
                        }
                        reg(loginParams)
                            .then(() => {
                                this.$message.success('注册成功,请等待管理员审核通过');
                                this.loading2 = false
                            })
                            .catch(() => {
                                this.loading2 = false
                            })
                    } else {
                        return false
                    }
                })
            }
        }
    }
</script>
<style>
    body {
        background: #fff;
    }
</style>
<style lang="scss" scoped>
    .login-container {
        /*box-shadow: 0 0px 8px 0 rgba(0, 0, 0, 0.06), 0 1px 0px 0 rgba(0, 0, 0, 0.02);*/
        -webkit-border-radius: 5px;
        border-radius: 5px;
        -moz-border-radius: 5px;
        background-clip: padding-box;
        margin: 160px auto;
        width: 350px;
        padding: 35px 35px 15px 35px;
        background: #fff;
        border: 1px solid #eaeaea;
        box-shadow: 0 0 25px #cac6c6;

        background: -ms-linear-gradient(top, #ace, #00C1DE);
        /* IE 10 */
        background: -moz-linear-gradient(top, #ace, #00C1DE);
        /*火狐*/
        background: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#ace), to(#00C1DE));
        /*谷歌*/
        background: -webkit-linear-gradient(top, #ace, #00C1DE);
        /*Safari5.1 Chrome 10+*/
        background: -o-linear-gradient(top, #ace, #00C1DE);
        /*Opera 11.10+*/

        .title {
            margin-bottom: 20px;
            text-align: center;
            color: #505458;
        }

        .yzm {
            width: 70%;
        }

        .yzm_img {
            margin-bottom: -10px;
        }

        .el-form-item {
            border: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(0, 0, 0, 0.1);
            border-radius: 5px;
            color: #454545;
        }
    }
</style>
