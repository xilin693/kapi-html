<template>
    <div class="icon-container">
        <el-tabs type="border-card" v-model="activeName" @tab-click="handleTab">
            <el-tab-pane label="运行" name="first">
                <el-form ref="form" label-width="80px" :model="formDetail">
                    <el-form-item label="">
                        <el-row :gutter="5">
                            <el-col :span="1">
                                <el-tooltip :content="selectItem" placement="top">
                                    <el-switch
                                            v-model="selectValue"
                                            active-color="#13ce66"
                                            inactive-color="#ff4949" @change="handleSwitch(formDetail.id, selectValue)">
                                    </el-switch>
                                </el-tooltip>
                            </el-col>
                            <el-col :span="6">
                                <el-select v-model="formDetail.env_id" value-key="item.id" @input="onInput()"
                                           @change="changeEnv()" placeholder="请选择开发环境" style="width: 100%;">
                                    <el-option v-for="item in envs" :key="item.id"
                                               :label="item.name + ' - ' + item.url_prefix + item.domain"
                                               :value="item.id"></el-option>
                                </el-select>
                            </el-col>
                            <el-col :span="9">
                                <el-input v-model="formDetail.uri" placeholder="网址" @input="watchInput">
                                    <el-select v-model="formDetail.method" slot="prepend" style="width: 130px">
                                        <el-option label="GET" value="get"></el-option>
                                        <el-option label="POST" value="post"></el-option>
                                        <el-option label="PUT" value="put"></el-option>
                                        <el-option label="DELETE" value="delete"></el-option>
                                    </el-select>
                                </el-input>
                            </el-col>
                            <el-col :span="2" v-if="tabType">
                                <el-button type="primary" @click.native="runData">运行</el-button>
                            </el-col>

                            <el-col :span="3" v-if="!tabType">
                                <el-input v-model="formDetail.route_url" placeHolder="源地址"></el-input>
                            </el-col>

                            <el-col :span="2">
                                <el-button type="success" @click="submitData">保存全部</el-button>
                            </el-col>
                        </el-row>
                    </el-form-item>
                    <el-form-item v-show="formDetail.path_data.length">
                        <h4 class="item-title3">路径参数</h4>
                        <el-row v-for="(item, index) in formDetail.path_data" :key="index" :gutter="5"
                                style="margin-bottom: 5px">
                            <el-col :span="6">
                                <el-input v-model="item.key" placeHolder="参数名称" value="" :readonly="true"></el-input>
                            </el-col>
                            <el-col :span="6">
                                <el-input v-model="item.value" placeHolder="参数值" value="" @input="onInput()"></el-input>
                            </el-col>
                            <el-col :span="8">
                                <el-input v-model="item.description" placeHolder="参数描述" @input="onInput()"></el-input>
                            </el-col>
                        </el-row>
                    </el-form-item>
                    <el-dialog title="导入Json" :visible.sync="jsonDialogVisible" width="500px">
                        <el-divider></el-divider>
                        <el-form-item :label="this.title" label-width="80px">
                            <template v-if="type =='put'">
                                <el-input type="textarea" v-model="jsonComment_put" rows="10"></el-input>
                            </template>
                            <template v-if="type =='back'">
                                <el-input type="textarea" v-model="jsonComment_back" rows="10"></el-input>
                            </template>
                        </el-form-item>
                        <div slot="footer" class="dialog-footer">
                            <el-button @click="jsonDialogVisible = false">取 消</el-button>
                            <el-button type="primary" @click.native="importJson(type)">确 定</el-button>
                        </div>
                    </el-dialog>
                    <el-dialog title="导入请求参数" :visible.sync="apiRelativeVisible" width="500px">
                        <el-divider></el-divider>
                        <el-form ref="formRelative" :model="formRelative">
                            <el-form-item label="请选择参数来源" label-width="120px">
                                <el-select v-model="formRelative.id" style="width: 300px">
                                    <el-option v-for="(item, index) in projects" :key="item.name" :label="item.name"
                                               :value="item.id"></el-option>
                                </el-select>
                            </el-form-item>
                            <el-form-item style="margin-left:50px">
                                <el-button type="primary" @click.native="importParam()">导入</el-button>
                                <el-button @click="apiRelativeVisible = false">取 消</el-button>
                            </el-form-item>
                        </el-form>
                    </el-dialog>
                    <el-tabs style="margin-left:50px" v-model="activeTab" @tab-click="handleClick">
                        <el-tab-pane label="模拟" name="simulate">
                            <el-form-item label="">
                                <ApiField title="Header" :fieldData.sync="formDetail.header_data" :tabIndex="0"
                                          :key="headerKey" inputType="header"></ApiField>
                            </el-form-item>
                            <template v-if="formDetail.method=='get' || formDetail.method=='delete'">
                                <el-form-item label="">
                                    <ApiField title="Query Params" :fieldData.sync="formDetail.query_data"
                                              tabIndex="0" :key="headerKey" inputType="any"></ApiField>
                                </el-form-item>
                            </template>
                            <template v-if="postUseJson > 0 && formDetail.method=='post'">
                                <el-row :gutter="5" id="post2">
                                    <el-col :span="2">
                                        <el-select v-model="formDetail.post_type" value-key="item.value"
                                                   placeholder="请选择" id="post_type">
                                            <el-option
                                                    v-for="item in postArray"
                                                    :key="item.value"
                                                    :label="item.label"
                                                    :value="item.value">
                                            </el-option>
                                        </el-select>
                                    </el-col>
                                </el-row>
                            </template>
                            <template v-if="formDetail.method=='post' && formDetail.post_type==0">
                                <el-form-item label="">
                                    <ApiField title="Form Data" :fieldData.sync="formDetail.form_data"
                                              tabIndex="0" :key="headerKey" inputType="any"></ApiField>
                                </el-form-item>
                            </template>
                            <template
                                    v-if="formDetail.method=='put' || (formDetail.method == 'post' && formDetail.post_type==1)">
                                <el-form-item label="" style="margin-bottom: 2px">
                                    <el-row>
                                        <el-col :span="19" style="margin-top: -3px">
                                            <el-button type="success" @click="showRaw" size="small">
                                                导入Json Raw
                                            </el-button>
                                            <el-button @click="jsonFormat" size="small">
                                                Format
                                            </el-button>
                                        </el-col>
                                    </el-row>
                                </el-form-item>
                                <el-form-item>
                                    <el-input type="textarea" id="put_textarea" v-model="formDetail.put_data" rows="10"
                                              v-show="this.rawText"></el-input>
                                </el-form-item>
                            </template>
                            <el-form-item>
                                <el-divider content-position="left" class="sub-main">Response</el-divider>
                                <div class="msgbox"
                                     :class="[(response.code<300 && response.code>=200) ? 'success' : 'fail']"
                                     v-show="response.code > 0">{{response.code}} - {{response.code_text}}
                                </div>
                            </el-form-item>
                            <el-form-item v-show="run">
                                <el-row>
                                    <el-col :span="10">
                                        <clip-board :text="response_data" @copy="handleCopy">
                                            <el-button v-show="response_show==2" icon="el-icon-s-grid" type="info">复制
                                            </el-button>
                                        </clip-board>
                                        <el-checkbox v-show="response_show==1" v-model="format_check"
                                                     @change="changeStyle">格式化
                                        </el-checkbox>
                                    </el-col>
                                    <el-col :span="10">
                                        <img :src="captchaImg" alt="验证码" class="yzm_img" v-if="showImg"/>
                                        <clip-board :text="captchaCode" @copy="handleCopy">&nbsp;
                                            <el-button v-if="showImg" icon="el-icon-menu">复制Code</el-button>
                                        </clip-board>
                                    </el-col>
                                </el-row>
                                <el-row>
                                    <div v-html="response_data" style="overflow-wrap: break-word;word-break: break-all;"
                                         v-show="response_show ==1"></div>
                                    <el-input type="textarea" style="overflow-wrap: break-word;word-break: break-all;"
                                              autosize v-model="this.response_data" rows="5"
                                              v-show="response_show ==2"></el-input>
                                </el-row>


                            </el-form-item>
                        </el-tab-pane>
                        <el-tab-pane label="文档" name="doc">
                            <el-form-item label="">
                                <ApiField title="Header" :fieldData.sync="formDetail.header_data" tabIndex="1"
                                          :key="headerKey" inputType="header"></ApiField>
                            </el-form-item>
                            <template v-if="formDetail.method=='get' || formDetail.method=='delete'">
                                <el-form-item label="">
                                    <ApiField title="Query Params" :fieldData.sync="formDetail.query_data"
                                              tabIndex="1" :key="headerKey" inputType="any"></ApiField>
                                </el-form-item>
                            </template>
                            <template v-if="formDetail.method=='post' && formDetail.post_type ==0">
                                <el-form-item label="">
                                    <ApiField title="Form Data" :fieldData.sync="formDetail.form_data"
                                              tabIndex="1" :key="headerKey" inputType="any"></ApiField>
                                </el-form-item>
                            </template>
                            <template
                                    v-if="formDetail.method=='put' || (formDetail.method=='post' && formDetail.post_type ==1)">
                                <el-form-item label="" style="margin-bottom: 2px">
                                    <div class="item-title3">导入JSON
                                        <el-button class="el-icon-plus" @click="showDialog('put', 'Put json')"
                                                   title="导入" round>导入
                                        </el-button>
                                    </div>
                                </el-form-item>
                            </template>
                            <template
                                    v-if="formDetail.method=='put' || (formDetail.method=='post' && formDetail.post_type ==1)">
                                <JsonBox :putData="formDetail.put_doc" dataType="put_doc" name="putTree"></JsonBox>
                            </template>
                            <el-form-item label="" style="margin-bottom: 2px">
                                <el-form-item label="" style="margin-bottom: 2px">
                                    <div class="item-title3">
                                        返回注释
                                        <el-button class="el-icon-plus" @click="showDialog('back', '返回数据')" title="导入"
                                                   round>导入
                                        </el-button>
                                    </div>
                                </el-form-item>
                            </el-form-item>
                            <JsonBox :putData="formDetail.return_data" dataType="return_data"
                                     name="returnTree"></JsonBox>
                            <el-form-item label="" style="margin-bottom: 5px">
                                <el-row>
                                    <h4 class="item-title3">接口备注</h4>
                                </el-row>
                            </el-form-item>
                            <el-form-item>
                                <div style="width:90%;">
                                    <tinymce id="d1"
                                             :other_options="tinyOptions"
                                             v-model="formDetail.comment"
                                    ></tinymce>
                                </div>
                            </el-form-item>
                        </el-tab-pane>
                    </el-tabs>
                </el-form>
            </el-tab-pane>
            <el-tab-pane label="预览" name="second" lazy>
                <Preview :apiId="this.apiId" :key="previewKey"></Preview>
            </el-tab-pane>
        </el-tabs>
    </div>
</template>
<script>
    import {getProjectEnv} from '@/api/env';
    import {userinfo} from '@/api/user'
    import {
        getApiDetail,
        setApiField,
        getRelativeApi,
        saveApiDetail,
        runApi,
        importJson,
        toQueryString,
        copyRelative
    } from '@/api/apis'
    import ApiField from "@/components/common/ApiField"
    import JsonBox from "@/components/common/JsonBox"
    import Preview from "@/components/common/Preview"
    import tinymce from 'vue-tinymce-editor'
    import VueJsonPretty from 'vue-json-pretty'
    import clipBoard from 'vue-copy-to-clipboard'
    import 'vue-json-pretty/lib/styles.css';

    export default {
        name: 'Detail',
        components: {ApiField, JsonBox, Preview, tinymce, VueJsonPretty, clipBoard},
        data() {
            return {
                postArray: [{
                    value: 0,
                    label: 'Form Data'
                }, {
                    value: 1,
                    label: 'Post Json'
                }],
                postUseJson: 0,
                showImg: false,
                captchaCode: '',
                captchaImg: '',
                apiRelativeVisible: false,
                formRelative: {
                    id: '',
                    field: 'return_data'
                },
                format_check: false,
                selectItem: '',
                selectValue: false,
                projects: [],
                previewKey: 0,
                list: [],
                activeName: 'first',
                uri: '',
                labelPosition: 'top',
                response_data: '',
                response_show: 1,
                tinyOptions: ({
                    menubar: false,
                    statusbar: false,
                    selector: "#d1",  // change this value according to your HTML
                    plugins: "autoresize",
                    autoresize_bottom_margin: 10
                }),
                formDetail: {
                    method: 'get',
                    uri: '/',
                    header_data: [],
                    put_data: [],
                    form_data: [],
                    query_data: [],
                    return_data: [],
                    path_data: [],
                    put_doc: [],
                    env_id: 0,
                    comment: '',
                    route_url: '',
                    post_type: 0,
                },
                menus: ['bold',	// 粗体
                    'underline',	// 下划线
                    'italic',	// 斜体
                    'strikethrough',	// 中线
                    'eraser',	// 清空格式
                    'forecolor',	// 文字颜色
                    'bgcolor',	// 背景颜色
                    '|',
                    'quote',	// 引用
                    'fontfamily',	// 字体
                    'fontsize',	// 字号
                    'head',	// 标题
                    'unorderlist',	// 无序列表
                    'orderlist',	// 有序列表
                    'alignleft',	// 左对齐
                    'aligncenter',	// 居中
                    'alignright',	// 右对齐
                ],
                jsonDialogVisible: false,
                attachDialogVisible: false,
                title: '',
                type: '',
                jsonComment_put: '',
                jsonComment_back: '',
                jsonComment_raw: '',
                headerKey: 0,
                rawText: 1,
                envs: [],
                response: {"code": 0},
                run: false,
                editorOption: {
                    modules: {
                        toolbar: [
                            ['bold', 'italic', 'underline', 'strike'],        // toggled buttons
                            ['blockquote', 'code-block']
                        ]
                    }
                },
                items: [],
                currentKey: '',
                tabType: 1,
                activeTab: 'simulate',
                returnKey: 0,
                docKey: 0,
                isEdit: 0,
                fix_header: [],
            }
        },
        props: ['apiId', 'roleId'],
        created() {
            this.init();

        },
        mounted: function () {
            this.$watch('formDetail', this.formUpdated, {
                deep: true
            })
        },
        methods: {
            formUpdated() {
                this.isEdit++;
                this.$emit('update:isEdit', this.isEdit);
            },
            init() {
                if (this.roleId > 1) {
                    this.activeName = 'second';
                }
                this.postUseJson = sessionStorage.getItem("postUseJson");
                getApiDetail({id: this.apiId}).then((rs) => {
                    this.formDetail = rs.data;

                    const def = [{'key': '', 'value': '', 'description': '', 'submit': true}];
                    this.mapField('header_data', rs, 1);
                    this.mapField('query_data', rs, 1);
                    this.mapField('form_data', rs, 1);
                    this.mapField('put_doc', rs, 3);
                    this.mapField('return_data', rs, 2);
                    this.mapField('path_data', rs, 2);
                    this.fix_header = this.formDetail.header_data;
                    let global_header;
                    getProjectEnv(this.$route.params.id).then((rs) => {
                        this.envs = rs.data;
                        if (this.envs[0]) {
                            this.formDetail.env_id = this.envs[0].id;
                            global_header = JSON.parse(this.envs[0].global_header);
                            this.setHeader(global_header);
                            this.headerKey++;
                        }
                    });
                    if (this.formDetail.comment == null) {
                        this.formDetail.comment = '';
                    }
                    this.selectItem = this.formDetail.complete ? '已完成' : '未完成';
                    this.selectValue = this.formDetail.complete ? true : false;
                    window.document.title = rs.data.name + ' - Kapi';
                    this.watchInput(rs.data.uri);
                })
            },
            changeStyle() {
                this.response_show = 2;
            },

            setHeader(global_header) {
                var _this = this;
                let header_array = [];
                this.fix_header.forEach(function (item, index) {
                    header_array.push(item.key);
                });

                global_header.forEach(function (item, index) {
                    let index2 = header_array.indexOf(item.key);
                    if (index2 >= 0) {
                        _this.formDetail.header_data[index2]['value'] = item.value;
                    } else {
                        _this.formDetail.header_data.push({
                            'submit': true,
                            'key': item.key,
                            'value': item.value,
                            'check': true,
                            'description': ''
                        });
                    }
                })
            },
            changeEnv() {
                let id = this.formDetail.env_id;
                for (let item of this.envs) {
                    if (item.id == id) {
                        let item_header = item.global_header ? JSON.parse(item.global_header) : [];
                        this.setHeader(item_header)
                    }
                }
            },
            mapField(field, rs, def) {
                let f = rs.data[field];
                var res;
                if (f && f != 'null' && f != '[]') {
                    res = JSON.parse(f);
                } else {
                    if (def == 1) {
                        res = [{'key': '', 'check': true, 'value': '', 'description': '', 'submit': true}];
                    } else if (def == 2) {
                        res = [];
                    } else if (def == 3) {
                        res = [{'key': '', 'check': true, 'type': 'string', 'description': ''}];
                    }
                }

                this.$set(this.formDetail, field, res);
            },
            handleSwitch(id, status) {
                this.selectItem = (status == true) ? '已完成' : '未完成';
                this.selectValue = (status == true) ? true : false;
                setApiField({id: id, complete: status ? 1 : 0}).then((rs) => {
                    this.formDetail.complete = status;
                    this.$message('状态已更新');
                })
            },
            handleTab(tab) {
                if (tab.name == 'second') {
                    this.previewKey++;
                }
            },
            handleClick(tab) {
                if (tab.name == 'simulate') {
                    this.tabType = 1;
                } else {
                    this.tabType = 0;
                }
                this.headerKey++;
            },
            handleClick2(tab) {
                this.tabType = 1;
            },
            watchInput(uri) {
                let newUri = uri.replace(/^\//, "");
                let uris = newUri.split('/')
                let paths = {};
                let newArr = []
                let i = 0;
                for (let el of uris) {
                    if (el.charAt(0) == ':') {
                        paths.key = el.substr(1);
                        if (typeof(this.formDetail.path_data[i]) == 'undefined') {
                            this.formDetail.path_data[i] = paths;
                        } else {
                            this.formDetail.path_data[i].key = paths.key;
                        }

                        ++i;
                    }
                }

                if (i == 0) {
                    this.formDetail.path_data = [];
                } else {
                    if (typeof(this.formDetail.path_data) == 'object') {
                        if (i < this.formDetail.path_data.length) {
                            this.formDetail.path_data.forEach(function (item, index) {
                                if (item.key != '') {
                                    newArr.push(item);
                                }
                            })
                            this.formDetail.path_data = newArr;
                        }
                    }
                }
            },
            showRaw() {
                this.apiRelativeVisible = true;
                getRelativeApi(this.apiId).then((rs) => {
                    this.projects = rs.data;
                });
            },
            showDialog(type, title) {
                this.jsonDialogVisible = true
                this.type = type
                this.title = title
            },
            handleCopy() {
                console.log('onCopy')
            },
            importJson(type) {
                if (type == 'back') {
                    this.formDetail.return_data = [];
                } else if (type == 'put') {
                    this.formDetail.put_doc = [];
                }

                importJson({'json': this['jsonComment_' + type]}).then((rs) => {
                    if (type == 'put') {
                        this.formDetail.put_doc = rs.data;
                    } else {
                        this.formDetail.return_data = rs.data;
                    }
                });

                let arr;
                arr = JSON.parse(this['jsonComment_' + type])
                this.jsonDialogVisible = false
            },
            runData() {
                this.run = true;
                this.format_check = false;
                let data = {...this.formDetail}
                data.return_data = JSON.stringify(data.return_data);
                data.put_doc = JSON.stringify(data.put_doc);
                data.path_data = JSON.stringify(data.path_data);
                let method = this.formDetail.method;
                let url = this.getUrl(this.formDetail.uri)
                let put_data;
                let header = {};
                if (data.header_data.length > 0) {
                    header = this.transData(data.header_data, false);
                }

                if (method == 'get') {
                    let getData = {};
                    if (data.query_data.length > 0) {
                        getData = this.transData(data.query_data, true);
                        var result = toQueryString(getData);
                        url = url + result;
                    }
                    this.crossMyDomain(url, 'GET', header, getData);
                } else if (method == 'post') {
                    if (data.post_type == 0) {
                        let form_data = this.transData(this.filterData(data.form_data), false);
                        this.crossMyDomain(url, 'POST', header, form_data);
                    } else {
                        if (data.put_data) {
                            try {
                                put_data = JSON.parse(data.put_data);
                            } catch (e) {
                                this.$message.warning('raw json格式有误');
                                this.response = {"code": 0};
                                return false;
                            }
                        }

                        header['Content-Type'] = "application/json";
                        this.crossMyDomain(url, 'POST', header, data.put_data);
                    }
                } else if (method == 'put') {
                    if (data.put_data) {
                        try {
                            put_data = JSON.parse(data.put_data);
                        } catch (e) {
                            this.$message.warning('raw json格式有误');
                            this.response = {"code": 0};
                            return false;
                        }
                    }

                    header['Content-Type'] = "application/json";
                    this.crossMyDomain(url, 'PUT', header, data.put_data);
                } else if (method == 'delete') {
                    let getData = {};
                    if (data.query_data.length > 0) {
                        getData = this.transData(data.query_data, true);
                        var result = toQueryString(getData);
                        url = url + result;
                    }
                    this.crossMyDomain(url, 'DELETE', header, getData);
                }


            },
            crossMyDomain(url, method, header, data) {
                const loading = this.openLoading();
                this.response.code = 0;
                crossRequest({
                    url: url,
                    method: method,
                    headers: header,
                    data: data,
                    success: (rs, header, data) => {
                        this.response.code = data.res.status;
                        this.response.code_text = data.res.statusText;
                        this.response.data = rs;
                        if (rs.substr(0, 1) == '{' || rs.substr(0, 1) == '[') {
                            this.response_show = 2;
                            this.response_data = JSON.stringify(JSON.parse(rs), null, 4);
                        } else {
                            this.response_show = 1;
                            this.response_data = rs;
                        }

                        loading.close();

                        if (this.formDetail.uri.indexOf("captcha") != -1) {
                            let res = JSON.parse(this.response_data);
                            let resImg = res.img ? res.img : res.blob;
                            this.captchaImg = resImg;
                            this.captchaCode = res.code;
                            this.showImg = true;
                        }
                    },
                    error: (rs, header, data) => {
                        if (!data.res.status) {
                            this.response_data = '请求失败';
                        } else {
                            this.response.code = data.res.status;
                            this.response.code_text = data.res.statusText;
                            this.response.data = data.res.body;
                            if (this.response.data.substr(0, 1) == '{' || this.response.data.substr(0, 1) == '[') {
                                this.response_show = 2;
                                this.response_data = JSON.stringify(JSON.parse(this.response.data), null, 4);
                            } else {
                                this.response_show = 1;
                                this.response_data = data.res.body
                            }
                        }
                        loading.close();
                    }
                });
            },
            transData(data, filter) {
                let getData = {};
                let itemValue = '';
                for (let item of data) {
                    if (item.submit && item.key) {
                        if (filter == true) {
                            // url地址栏中特殊字符转义
                            itemValue = item.value
                                .replace(/\=/g, "%3D")
                                .replace(/\+/g, "%2B")
                                .replace(/\?/g, "%3F")
                                .replace(/\#/g, "%23")
                                .replace(/\&/g, "%26");
                        } else {
                            itemValue = item.value;
                        }
                        getData[item.key] = itemValue;
                    }
                }

                return getData;
            },
            getUrl(uri) {
                let urlPrefix;
                if (this.formDetail.env_id < 1) {
                    this.$message.warning('环境变量未设定');
                    return false;
                } else {
                    for (let item of this.envs) {
                        if (item.id == this.formDetail.env_id) {
                            urlPrefix = item.url_prefix + item.domain;
                        }
                    }
                }
                let data = this.formDetail.path_data;
                let newUri = uri.replace(/^\//, "");
                if (data.length > 0) {
                    data.forEach((item) => {
                        newUri = newUri.replace(':' + item.key, item.value);
                    })
                }

                return urlPrefix + '/' + newUri;
            },
            filterData(data) {
                let newData = [];
                if (data) {
                    for (let item of data) {
                        if (item.submit == true) {
                            newData.push(item);
                        }
                    }
                    return newData;
                }
            },
            submitData() {
                let data = {...this.formDetail}
                data.form_data = JSON.stringify(data.form_data);
                data.header_data = this.getHeaderData();
                data.header_data = JSON.stringify(data.header_data);
                data.query_data = JSON.stringify(data.query_data);
                data.return_data = JSON.stringify(data.return_data);
                data.put_doc = JSON.stringify(data.put_doc);
                data.path_data = JSON.stringify(data.path_data);
                data.project_id = this.$route.params.id;
                saveApiDetail(data).then((rs) => {
                    this.isEdit = 0;
                    this.$emit('update:isEdit', this.isEdit);
                    this.$message.success('保存成功')
                })
            },
            getHeaderData() {
                var headerData = JSON.parse(JSON.stringify(this.formDetail.header_data));

                return headerData;
            },
            onInput() {
                this.$forceUpdate()
            },
            jsonFormat() {
                this.formDetail.put_data = JSON.stringify(JSON.parse(this.formDetail.put_data), null, 4);
            },
            importParam() {
                let params = {};
                if (!this.formRelative.id) {
                    this.$message.error('请选择接口');
                } else {
                    params.new_id = this.formRelative.id;
                    copyRelative(params).then((rs) => {
                        this.formDetail.put_data = JSON.stringify(rs.data);
                        this.apiRelativeVisible = false;
                    })
                }
            }
        }
    }

</script>
<style>
    .el-col {
        min-height: 1px;
    }

    .own-box {
        margin-top: 60px;
        margin-left: -20px;
        overflow: hidden;
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

    .el-tabs__item.is-active {
        background-color: #42b983;
        color: #fff;
    }

    .el-tabs__active-bar {
        background-color: #42b983;
    }

    .el-tabs__item {
        padding: 0 10px !important;
    }

    .msgbox.fail {
        background-color: #f56a00;
    }

    .msgbox.success {
        background-color: #00a854;
    }

    .el-form-item__content {
        line-height: 30px !important;
    }

    .msgbox {
        padding-left: 1em;
        color: #fff;
        transition: all .2s;
        position: relative;
        border-radius: 2px;
        font-weight: bold;
        font-size: 1.5em;
    }

    .response_text {
        border: 1px solid #ced7ce;
        background-color: #f5f5f5;
        padding: 5px;
        font-size: 13px;
        font-weight: bold;
        /*overflow-x: scroll;*/
        word-break: break-all;
    }

    .item-title3 {
        clear: both;
        font-weight: 400;
        margin-top: .48rem;
        border-left: 3px solid #2395f1;
        padding-left: 8px;
    }

    #post_type.el-input__inner {
        padding: 0px;
        font-size: 12px;
        border: 0px solid #fff !important;
    }


</style>
<style scoped>

    .yzm_img {
        width: 110px;
        height: 39px;
        margin-bottom: -15px;
    }

    #post2 >>> .el-icon-arrow-up:before {
        color: #000 !important;
    }
</style>
