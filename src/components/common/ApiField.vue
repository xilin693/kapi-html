<template>
<el-form-item label="">
    <el-collapse v-model="activeNames">
        <el-collapse-item name="1">
            <template slot="title">
                <el-row style="margin-bottom: 8px">
                    <div class="item-title3">{{ title }}
                        <el-button class="el-icon-plus" @click.stop="addField" title="单个添加" circle></el-button>
                        <el-button class="el-icon-plus" @click.stop="addFieldPlus" title="批量添加" round>批量</el-button>
                    </div>
                </el-row>
            </template>
            <template>
                <div style="margin-top: 20px">
                    <draggable v-model="myField" :group="dragName" handle=".handle" @end="dragEnd">
            <div v-for="(item, index) in fieldData" :key="index">
                <el-row :gutter="5" style="margin-bottom: 5px;">
                    <el-col :span="1" v-if="tabIndex==0">                    <span class="handle">
                    <i class="el-icon-sort"></i>
                </span><el-checkbox v-model="item.submit" @input="onInput()">
                    </el-checkbox></el-col>
                    <el-col :span="2" v-if="tabIndex==1"><el-checkbox v-model="item.check" @input="onInput()">必填
                    </el-checkbox></el-col>
                    <el-col :span="7">
                        <template v-if="inputType == 'header'">
                            <el-autocomplete
                                    class="inline-input"
                                    v-model="item.key"
                                    :fetch-suggestions="querySearch"
                                    placeholder="参数名" style="width:100%"
                            ></el-autocomplete>
                        </template>
                        <template v-else>
                            <el-input placeholder="参数名" v-model="item.key" @input="onInput()"></el-input>
                        </template>

                    </el-col>
                    <template v-if="tabIndex == 0">
                    <el-col :span="12">
                        <el-input placeholder="参数值" type="textarea" :autosize="{ minRows: 1.3}" v-model="item.value" @input="onInput()"></el-input>
                    </el-col>
                    </template>
                    <template v-if="tabIndex == 1">
                    <el-col :span="12">
                        <el-input placeholder="参数说明" v-model="item.description" @input="onInput()"></el-input>
                    </el-col>
                    </template>
                    <el-col :span="1">
                        <i class="el-icon-delete" @click="delField(index)"></i>
                    </el-col>
                </el-row>
            </div>
                    </draggable>
            <el-dialog title="批量添加参数" :visible.sync="batchDialogVisible" width="500px">
                <el-divider></el-divider>
                <el-row>key:value格式 </el-row>
                        <el-input type="textarea" v-model="batchValue" rows="10"></el-input>
                <div slot="footer" class="dialog-footer">
                    <el-button @click="batchDialogVisible = false">取 消</el-button>
                    <el-button type="primary" @click.native="importValue()">确 定</el-button>
                </div>
            </el-dialog>
                </div>
        </template>
        </el-collapse-item>
    </el-collapse>
</el-form-item>
</template>
<script>
    import draggable from 'vuedraggable'
    export default {
        name: 'ApiField',
        data() {
            return {
                batchDialogVisible: false,
                type: '',
                myField: this.fieldData,
                batchValue: '',
                activeNames:['1'],
                dragName: 'drag' + Math.random()
            }
        },
        components: {
            draggable
        },
        props: ['title', 'fieldData', 'tabIndex', 'inputType'],
        created() {
        },
        mounted() {
            this.headers = this.loadAll();
        },
        methods: {
            querySearch(queryString, cb) {
                var headers = this.headers;
                var results = queryString ? headers.filter(this.createFilter(queryString)) : headers;
                // 调用 callback 返回建议列表的数据
                cb(results);
            },
            createFilter(queryString) {
                return (header) => {
                    return (header.value.toLowerCase().indexOf(queryString.toLowerCase()) === 0);
                };
            },
            loadAll() {
                return [
                    { "value": "Authorization" },
                    { "value": "Content-Type" },
                    { "value": "Accept-Language" },
                    { "value": "Cookie" },
                    { "value": "User-Agent" },
                    { "value": "Host" },
                    { "value": "Referer" },
                    { "value": "Accept" },
                    { "value": "Accpet-Charset" },
                    { "value": "Accept-Encoding" },
                    { "value": "Accept-Ranges" },
                    { "value": "Cache-Control" },
                    { "value": "Connection" }
                ];
            },
            dragEnd() {
                this.$emit('update:fieldData', this.myField)
            },
            onInput() {
                this.$forceUpdate();
            },
            addField() {
                this.fieldData.push({
                    'submit': true,
                    'key': '',
                    'value': '',
                    'check': true,
                    'description': ''
                })
                this.$forceUpdate();
            },
            addFieldPlus() {
                this.batchDialogVisible = true
            },
            delField(index) {
                this.fieldData.splice(index, 1)
                this.$forceUpdate();
            },
            importValue() {
                let items = this.batchValue.split(/\n/);
                for (let item of items) {
                    let tinyItem = item.split(':');
                    //let tinyItem = /(\w+):(.+)/.exec(item)
                    let itemData = {};
                    itemData.key = tinyItem[0];
                    itemData.submit = true;
                    itemData.value = tinyItem[1];
                    itemData.check = true;
                    this.fieldData.push(itemData);
                    this.batchDialogVisible = false;
                }
            }
        }
    }
</script>

<style>
    .handle {
        padding: 5px;
        margin-right: 5px;
        cursor: move;
    }

    .item-title {
        background-color: #ccc;
        line-height: 35px !important;
        height: 35px !important;
        padding-left: 5px;
    }

    .el-icon-delete {
        margin-left:5px;
        cursor:pointer;
    }

    .el-dialog .el-divider--horizontal {
        margin: 10px 0 !important;
    }

    .el-collapse-item__wrap {
        border-bottom: none;
    }

    .el-collapse-item__content {
        padding-bottom: 0;
    }

    .el-collapse-item__header.is-active {
        border-bottom: 1px #ebeef5 solid;
    }
</style>