<template>
    <div style="margin-left:80px; margin-top: 20px;" id="jsonBox">
        <el-tree :expand-on-click-node="false" :data="putData" node-key="id">
        <span class="custom-tree-node" slot-scope="{ node, data }">
           <el-row :gutter="5">
             <el-col :span="2" v-if="dataType=='put_doc'">
                <el-checkbox v-model="data.check">必填</el-checkbox>
            </el-col>
            <el-col :span="5">
                <el-input v-model="data.key" placeHolder="参数名称"></el-input>
            </el-col>
            <el-col :span="4">
                <el-select v-model="data.type" placeholder="类型" style="width:100%;" @change="handelChange(node, data)">
                    <el-option label="Object" value="object"></el-option>
                    <el-option label="Int" value="int"></el-option>
                    <el-option label="string" value="string"></el-option>
                    <el-option label="boolean" value="boolean"></el-option>
                    <el-option label="Array" value="array"></el-option>
                </el-select>
            </el-col>
            <el-col :span="10">
                <el-input placeHolder="备注" v-model="data.description"
                          @input="onInput()"></el-input>
            </el-col>
            <template v-if="data.type == 'object' || data.type=='array'">
            <el-col :span="1">
                <template v-if="!node.parent.parent">
                <i class="el-icon-plus" @click.stop="addNode(node, data)" title="添加兄弟节点"></i>
                </template>
                <i class="el-icon-circle-plus-outline" @click.stop="addChildNode(data)" title="添加子节点"></i>
                <i class="el-icon-delete" @click.stop="delNode(node, data)" title="删除节点"></i>
                <el-button class="el-icon-plus" @click.stop="showDialog(data)" title="附加字段" round>批量</el-button>
            </el-col>
            </template>
            <template v-else>
            <el-col :span="1">
                <template v-if="node.parent.parent == null">
                <i class="el-icon-plus" @click.stop="addNode(node, data)" title="添加兄弟节点"></i>
                </template>
                <i class="el-icon-delete" @click.stop="delNode(node, data)" title="删除节点"></i>
            </el-col>
           </template>
           </el-row>
        </span>
        </el-tree>
        <el-dialog title="附加字段" :visible.sync="attachDialogVisible" width="500px">
            <el-divider></el-divider>
            <el-row>key:value格式</el-row>
            <el-input type="textarea" v-model="batchValue" rows="10"></el-input>
            <div slot="footer" class="dialog-footer">
                <el-button @click="attachDialogVisible = false">取 消</el-button>
                <el-button type="primary" @click.native="attachValue()">确 定</el-button>
            </div>
        </el-dialog>
    </div>
</template>
<style>
    #jsonBox .el-tree-node__content {
        height: 52px;
    }

    .custom-tree-node {
        width: 100%;
    }
</style>
<script>
    import {userinfo} from '@/api/user';
    import {getApiDetail, saveApiDetail} from '@/api/apis';

    export default {
        name: 'JsonBox',
        data() {
            return {
                id: 5000,
                attachDialogVisible: false,
                batchValue: '',
                batchData: {},
            }
        },
        props: ['putData', 'dataType', 'name'],
        created() {
            this.init()
        },
        methods: {
            init() {
            },
            addNode(node, data) {
                const parent = node.parent;
                const children = parent.data.children || parent.data;
                const index = children.findIndex(d => d.id === data.id);
                let id = this.utils.rand(100, 10000000);
                let item = {
                    'id': id,
                    'key': '',
                    'check': false,
                    'type': 'string',
                    'description': '',
                };

                this.putData.splice(index + 1, 0, item);
            },
            handelChange(node, data) {
                if ((data.type == 'object' || data.type == 'array')  && !node.data.children) {
                    this.$set(data, 'children', []);
                    let id = this.utils.rand(100, 10000000);
                    const newChild = {
                        'id': id,
                        'key': '',
                        'check': true,
                        'type': 'string',
                        'description': ''
                    };
                    data.children.push(newChild);
                }

                if ((data.type != 'object' || data.type == 'array') && node.data.children) {
                    node.data.children = undefined;
                }
            },
            rand(min, max) {
                if (min == null && max == null)
                    return 0;

                if (max == null) {
                    max = min;
                    min = 0;
                }
                return min + Math.floor(Math.random() * (max - min + 1));
            },
            addChildNode(data) {
                let id = this.utils.rand(100, 10000000);
                const newChild = {
                    'id': id,
                    'key': '',
                    'check': true,
                    'type': 'string',
                    'description': ''
                };
                if (!data.children) {
                    this.$set(data, 'children', []);
                }
                data.children.push(newChild);
            },
            delNode(node, data) {
                const parent = node.parent;
                const children = parent.data.children || parent.data;
                const index = children.findIndex(d => d.id === data.id);
                children.splice(index, 1);
            },
            onInput() {
                //this.putKey++;
            },
            showDialog(data) {
                this.attachDialogVisible = true;
                this.batchData = data;
            },
            attachValue() {
                let items = this.batchValue.split(/\n/);
                for (let item of items) {
                    let tinyItem = item.split(':');
                    let id = this.utils.rand(100, 10000000);
                    const newChild = {
                        'id': id,
                        'key': tinyItem[0],
                        'check': true,
                        'type': 'string',
                        'description': tinyItem[1]
                    };
                    if (!this.batchData.children) {
                        this.$set(this.batchData, 'children', []);
                    }

                    this.batchData.children.push(newChild);
                    this.attachDialogVisible = false
                }
            }
        }
    }

</script>
