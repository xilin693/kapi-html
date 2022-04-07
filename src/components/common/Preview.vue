<template>
    <div class="icon-contain">
        <el-row style="margin-bottom: 5px">
            <h2 :span="5" class="item-title2">基本信息</h2>
        </el-row>
        <el-row :gutter="20" class="like-table">
            <el-col :span="3" class="item-key">接口名称:</el-col>
            <el-col :span="5" class="item-value">{{ api.name }}</el-col>
            <el-col :offset="2" :span="3" class="item-key">创建人:</el-col>
            <el-col :span="5" class="item-value">{{ api.realname }}</el-col>
        </el-row>
        <el-row :gutter="20" class="like-table">
            <el-col :span="3" class="item-key">状态:</el-col>
            <el-col :span="5" class="item-value">{{ api.complete ? '完成' : '未完成' }}</el-col>
            <el-col :offset="2" :span="3" class="item-key">更新时间</el-col>
            <el-col :span="5" class="item-value">{{api.utime | formatDate}}</el-col>
        </el-row>
        <el-row :gutter="20" class="like-table">
            <el-col :span="3" class="item-key">接口路径:</el-col>
            <el-col :span="5" style="color:cornflowerblue">{{api.method}}::{{api.uri}}</el-col>
            <el-col :offset="2" :span="3" class="item-key">源地址</el-col>
            <el-col :span="5" class="item-value">{{api.route_url}}</el-col>
        </el-row>
        <el-row style="margin-bottom: -30px !important; margin-top:50px">
            <h2 class="item-title2">请求参数</h2>
        </el-row>
        <div class="key-name">
            <h4>路径参数</h4>
        </div>
        <div class="sub-name">
            <el-table :border="true"
                      :data="api.path_data"
                      style="width: 100%" :cell-style="headerStyle" class="table-key">
                <el-table-column
                        prop="key"
                        label="参数名称"
                        width="180">
                </el-table-column>
                <el-table-column
                        prop="value"
                        label="参数示例"
                        width="280">
                </el-table-column>
                <el-table-column
                        prop="check"
                        label="必填"
                        width="150">
                    <template slot-scope="scope">
                        <div style="margin-left:10px">是</div>
                    </template>
                </el-table-column>
                <el-table-column
                        prop="description"
                        label="参数描述">
                </el-table-column>
            </el-table>
        </div>
        <div class="key-name">
            <h4>Header</h4>
        </div>
        <div class="sub-name">
            <el-table :border="true"
                      :data="api.header_data"
                      style="width: 100%" :cell-style="headerStyle" class="table-key">
                <el-table-column
                        prop="key"
                        label="参数名称"
                        width="180">
                </el-table-column>
                <el-table-column
                        prop="value"
                        label="参数示例"
                        width="280">
                </el-table-column>
                <el-table-column
                        prop="check"
                        label="必填"
                        width="150">
                    <template slot-scope="scope">
                        <div style="margin-left:10px">{{scope.row.check ? '是' : '否'}}</div>
                    </template>
                </el-table-column>
                <el-table-column
                        prop="description"
                        label="参数描述">
                </el-table-column>
            </el-table>
        </div>
        <template v-if="api.method =='get' || api.method== 'delete'">
            <div class="key-name">
                <h4>Query Params</h4>
            </div>
            <el-row class="sub-name">
                <el-table :border="true"
                          :data="api.query_data"
                          style="width: 100%" :cell-style="headerStyle" class="table-key">
                    <el-table-column
                            prop="key"
                            label="参数名称"
                            width="180">
                    </el-table-column>
                    <el-table-column
                            prop="value"
                            label="参数示例"
                            width="280">
                    </el-table-column>
                    <el-table-column
                            prop="check"
                            label="必填"
                            width="150">
                        <template slot-scope="scope">
                            <div style="margin-left:10px">{{scope.row.check ? '是' : '否'}}</div>
                        </template>
                    </el-table-column>
                    <el-table-column
                            prop="description"
                            label="参数描述">
                    </el-table-column>
                </el-table>
            </el-row>
        </template>
        <template v-if="api.method =='post'">
            <template v-if="api.post_type == 0">
            <div class="key-name">
                <h4>Form Data</h4>
            </div>
            <el-row class="sub-name">
                <el-table :border="true"
                          :data="api.form_data"
                          style="width: 100%" :cell-style="headerStyle" class="table-key">
                    <el-table-column
                            prop="key"
                            label="参数名称"
                            width="180">
                    </el-table-column>
                    <el-table-column
                            prop="value"
                            label="参数示例"
                            width="280">
                    </el-table-column>
                    <el-table-column
                            prop="check"
                            label="必填">
                        <template slot-scope="scope">
                            <div style="margin-left:10px">{{scope.row.check ? '是' : '否'}}</div>
                        </template>
                    </el-table-column>
                    <el-table-column
                            prop="description"
                            label="参数描述">
                    </el-table-column>
                </el-table>
            </el-row>
            </template>
            <template v-else>
            <div class="key-name">
                <h4>Post Json</h4>
            </div>
            <el-row class="sub-name">
                <el-table :border="true"
                          :data="api.put_doc"
                          :cell-style="headerStyle"
                          class="table-key"
                          style="width: 100%;margin-bottom: 20px;"
                          row-key="id"
                          :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
                >
                    <el-table-column
                        prop="key"
                        label="参数名称"
                        width="180">
                    </el-table-column>
                    <el-table-column
                        prop="type"
                        label="参数类型"
                        width="280">
                    </el-table-column>
                    <el-table-column
                        width="150"
                        prop="check"
                        label="必填">
                        <template slot-scope="scope">
                            <div style="margin-left:10px">{{scope.row.check ? '是' : '否'}}</div>
                        </template>
                    </el-table-column>
                    <el-table-column
                        prop="description"
                        label="参数描述">
                    </el-table-column>
                </el-table>
            </el-row>
            </template>
        </template>
        <template v-if="api.method =='put'">
            <div class="key-name">
                <h4>Put Doc</h4>
            </div>
            <el-row class="sub-name">
                <el-table :border="true"
                          :data="api.put_doc"
                          :cell-style="headerStyle"
                          class="table-key"
                          style="width: 100%;margin-bottom: 20px;"
                          row-key="id"
                          :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
                >
                    <el-table-column
                            prop="key"
                            label="参数名称"
                            width="180">
                    </el-table-column>
                    <el-table-column
                            prop="type"
                            label="参数类型"
                            width="280">
                    </el-table-column>
                    <el-table-column
                            width="150"
                            prop="check"
                            label="必填">
                        <template slot-scope="scope">
                            <div style="margin-left:10px">{{scope.row.check ? '是' : '否'}}</div>
                        </template>
                    </el-table-column>
                    <el-table-column
                            prop="description"
                            label="参数描述">
                    </el-table-column>
                </el-table>
            </el-row>
        </template>
        <div>
            <h2 class="item-title2">返回参数</h2>
        </div>
        <el-row class="sub-name">
            <el-table :border="true"
                      :data="api.return_data"
                      :cell-style="headerStyle"
                      class="table-key"
                      style="width: 100%;margin-bottom: 20px;"
                      row-key="id"
                      :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
            >
                <el-table-column
                        prop="key"
                        label="参数名称"
                        width="180">
                </el-table-column>
                <el-table-column
                        prop="type"
                        label="参数类型"
                        width="180">
                </el-table-column>
                <el-table-column
                        prop="description"
                        label="参数描述">
                </el-table-column>
            </el-table>
        </el-row>
        <div class="container">
            <div style="margin-bottom: -20px;">
                <h2 class="item-title2">接口备注</h2>
            </div>
            <el-row class="key-comment">
                <el-col :span="24">
                    <div v-html="api.comment" id="api_comment"></div>
                </el-col>
            </el-row>
        </div>
    </div>
</template>
<script>
    import { getApiDetail, getRelativeApi, copyRelative } from "@/api/apis";

    export default {
        data() {
            return {
                api: {
                    header_data: [],
                    query_data: [],
                    path_data: [],
                    form_data: [],
                    put_doc: [],
                    return_data: []
                }
            }
        },
        filters: {
            formatDate: function (value) {
                if (value > 0) {
                    let date = new Date(parseInt(value) * 1000);
                    let Y = date.getFullYear() + '-';
                    let M = date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) + '-' : date.getMonth() + 1 + '-';
                    let D = date.getDate() < 10 ? '0' + date.getDate() + ' ' : date.getDate() + ' ';
                    let h = date.getHours() < 10 ? '0' + date.getHours() + ':' : date.getHours() + ':';
                    let m = date.getMinutes() < 10 ? '0' + date.getMinutes() + ':' : date.getMinutes() + ':';
                    let s = date.getSeconds() < 10 ? '0' + date.getSeconds() : date.getSeconds();
                    return Y + M + D + h + m + s;
                } else {
                    return '';
                }
            }
        },
        created() {
            this.init()
        },
        props: ['apiId'],
        methods: {
            init() {
                getApiDetail({'id': this.apiId}).then((rs) => {
                    this.api = rs.data;
                    this.api.header_data = (rs.data.header_data && rs.data.header_data != 'null') ? JSON.parse(rs.data.header_data) : [{
                        'key': '',
                        'value': '',
                        'description': ''
                    }]
                    this.api.form_data = (rs.data.form_data && rs.data.form_data != 'null') ? JSON.parse(rs.data.form_data) : [{
                        'key': '',
                        'value': '',
                        'description': ''
                    }]
                    this.api.query_data = (rs.data.query_data && rs.data.query_data != 'null') ? JSON.parse(rs.data.query_data) : [{
                        'key': '',
                        'value': '',
                        'description': ''
                    }]
                    this.api.put_doc = (rs.data.put_doc && rs.data.put_doc != 'null') ? JSON.parse(rs.data.put_doc) : [];
                    this.api.return_data = (rs.data.return_data && rs.data.return_data != 'null') ? JSON.parse(rs.data.return_data) : []
                    this.api.path_data = (rs.data.path_data && rs.data.path_data != 'null') ? JSON.parse(rs.data.path_data) : []
                })
            },
            headerStyle() {
                return 'padding:5px';
            }
        }
    }
</script>
<style>
    .jsonBox .el-tree-node__content {
        height: 40px;
    }
</style>
<style scoped lang="scss">
    .el-row {
        margin-bottom: 30px;
        font-size: 14px;
    }

    .item-title2 {
        clear: both;
        font-weight: 400;
        margin-top: .48rem;
        margin-bottom: 50px;
        border-left: 3px solid #2395f1;
        padding-left: 8px;
    }

    .item-key {
        color: #0d1b3ea6;
        font-weight: 700;
        text-align: left;
        width: 100px;
        padding-left: 10px;
        font-size: 13px;
    }

    .table-key {
        color: #0d1b3ea6;
        font-size: 13px;
    }

    .item-value {
        color: #0d1b3ea6;
        text-align: left;
        font-size: 13px;
    }

    .el-col-8, .el-col-6 {
        word-wrap: break-word !important;
    }

    .like-table {
        margin-left: 30px !important;
    }

    .key-name {
        margin-left: 30px;
        line-height: 20px;
    }

    .sub-name {
        margin: -15px 0 50px 30px;
    }

    .key-comment {
        marigin: -20px 0 0 30px !important;
    }

    .sub-title {
        font-weight: bold;
        width: 100px;
        border-bottom: 2px #000 solid;
    }

</style>
