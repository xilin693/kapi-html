<template>
    <el-container class="container">
        <el-header>
            <TopBar></TopBar>
        </el-header>
        <el-container>
            <el-aside class="left-aside" width="260px">
                <div class="menu-toggle">
                    <el-button size="small" @click="setting" type="primary">设置</el-button>
                    <el-button size="small" @click="showList" type="info">接口列表</el-button>
                    <el-button size="small" @click="showAddDialog" type="success">添加分类</el-button>
                </div>
                <el-scrollbar wrap-class="scrollbar-wrapper" class="myscrollbar">
                <div id="box">
                    <el-tree :data="tree" @node-click="handleNodeClick"  accordion ref="myTree" node-key="id"
                             :default-expanded-keys="defaultKey"
                             draggable
                             :allow-drop="allowDrop"
                    @node-drop="sortTree">
                <span class="custom-tree-node show-hide" slot-scope="{ node, data }">
                  <span style="overflow: hidden">{{ node.label }}</span>
                    <template v-if="!data.children && data.pid > 0">
                    <span style="display:none;">
                    <el-button type="text" size="mini" @click.stop="() => showEditDialog(data,  node.parent.data.id)"><i
                            class="el-icon-edit"/></el-button>
                    <el-button type="text" size="mini" @click.stop="() => showCopyApiDialog(data, node.parent.data.id)"><i
                            class="el-icon-copy-document"/></el-button>
                    <el-button type="text" size="mini" @click.stop="() => del(data.id, data.pid)"><i
                            class="el-icon-delete"/></el-button>
                    </span>
                    </template>
                    <template v-else>
                    <span style="display:none;">
                    <el-button type="text" size="mini" @click.stop="() => showCopyCategoryDialog(data)"><i
                            class="el-icon-copy-document"/></el-button>
                    <el-button type="text" size="mini" @click.stop="() => showApiDialog(data.id)"><i
                            class="el-icon-plus"/></el-button>
                    <el-button type="text" size="mini" @click.stop="() => showCategoryDialog(data)"><i
                            class="el-icon-edit"/></el-button>
                        <template v-if="!data.children">
                            <el-button type="text" size="mini" @click.stop="() => del(data.id)"><i
                                    class="el-icon-delete"/></el-button>
                        </template>
                    </span>
                    </template>
                </span>
                    </el-tree>

                </div>
                </el-scrollbar>
            </el-aside>
            <el-main>
                <el-scrollbar class="myscrollbar">
                <template v-if="handleClick == 'show'">
                    <ApiList :projectId="projectId" @changeDetail="changeDetail"></ApiList>
                </template>
                <template v-else-if="handleClick == 'setting'">
                    <Setting :projectId="projectId" :accountId="userInfo.id"></Setting>
                </template>
                <template v-else>
                    <Detail :apiId="apiId" :key="detailKey" :projectId="projectId" :isEdit.sync="isEdit" :roleId="roleId"></Detail>
                </template>
                </el-scrollbar>
            </el-main>
            <div style="clear:both"></div>
            <el-dialog :title="categoryTitle" :visible.sync="categoryDialogVisible" width="400px">
                <el-form :model="form">
                    <el-form-item label="分类名称" :label-width="formLabelWidth">
                        <el-input v-model="form.name" autocomplete="off" ref="addCategory"></el-input>
                    </el-form-item>
                </el-form>
                <div slot="footer" class="dialog-footer">
                    <el-button @click="categoryDialogVisible = false">取 消</el-button>
                    <el-button type="primary" @click.native="addSubmit()">确 定</el-button>
                </div>
            </el-dialog>
            <el-dialog title="修改接口" :visible.sync="editDialogVisible" width="400px" :close-on-click-modal="false">
                <el-form :model="formEdit">
                    <el-form-item label="接口名称" :label-width="formLabelWidth">
                        <el-input v-model="formEdit.name" autocomplete="off"></el-input>
                    </el-form-item>
                    <el-form-item label="接口分类" :label-width="formLabelWidth">
                        <el-select v-model="formEdit.category">
                            <el-option v-for="item in categories" :key="item.id" :label="item.name"
                                       :value="item.id"></el-option>
                        </el-select>
                    </el-form-item>
                </el-form>
                <div slot="footer" class="dialog-footer">
                    <el-button @click="editDialogVisible = false">取 消</el-button>
                    <el-button type="primary" @click.native="editApiName">确 定</el-button>
                </div>
            </el-dialog>
            <el-dialog title="复制接口" :visible.sync="copyApiDialogVisible" width="400px" :close-on-click-modal="false">
                <el-form :model="formCopy">
                    <el-form-item label="接口分类" :label-width="formLabelWidth">
                        <el-select v-model="formCopy.category">
                            <el-option v-for="item in categories" :key="item.id" :label="item.name"
                                       :value="item.id"></el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="接口名称" :label-width="formLabelWidth">
                        <el-input v-model="formCopy.name" autocomplete="off"></el-input>
                    </el-form-item>
                    <span style="color:red"> * 同分类下不允许有相同名称的接口</span>
                </el-form>
                <div slot="footer" class="dialog-footer">
                    <el-button @click="copyApiDialogVisible = false">取 消</el-button>
                    <el-button type="primary" @click.native="copy(0)">确 定</el-button>
                </div>
            </el-dialog>
            <el-dialog title="复制分类" :visible.sync="copyCategoryDialogVisible" width="400px" :close-on-click-modal="false">
                <el-form :model="formCategoryCopy">
                    <el-form-item label="项目名称" :label-width="formLabelWidth">
                        <el-select v-model="formCategoryCopy.project">
                            <el-option
                                    v-for="item in nav"
                                    :key="item.id"
                                    :label="item.name"
                                    :value="item.id">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="分类名称" :label-width="formLabelWidth">
                        <el-input v-model="formCategoryCopy.name" autocomplete="off"></el-input>
                    </el-form-item>
                    <span style="color:red"> * 同项目下不允许有相同名称的分类</span>
                </el-form>
                <div slot="footer" class="dialog-footer">
                    <el-button @click="copyCategoryDialogVisible = false">取 消</el-button>
                    <el-button type="primary" @click.native="copy(1)">确 定</el-button>
                </div>
            </el-dialog>
            <el-dialog title="添加接口" :visible.sync="apiDialogVisible" width="400px">
                <el-form :model="formApi">
                    <el-form-item label="接口分类" :label-width="formLabelWidth">
                        <el-select v-model="formApi.category">
                            <el-option v-for="item in categories" :key="item.id" :label="item.name"
                                       :value="item.id"></el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="接口名称" :label-width="formLabelWidth">
                        <el-input v-model="formApi.name" ref="addApi"></el-input>
                    </el-form-item>
                    <el-form-item label="接口路径" :label-width="formLabelWidth">
                        <el-row>
                            <el-col :span="8">
                                <el-select width="80px" v-model="formApi.method">
                                    <el-option label="GET" value="get"></el-option>
                                    <el-option label="POST" value="post"></el-option>
                                    <el-option label="PUT" value="put"></el-option>
                                    <el-option label="DELETE" value="delete"></el-option>
                                </el-select>
                            </el-col>
                            <el-col :span="16">
                                <el-input v-model="formApi.uri"></el-input>
                            </el-col>
                        </el-row>
                    </el-form-item>
                </el-form>
                <div slot="footer" class="dialog-footer">
                    <el-button @click="apiDialogVisible = false">取 消</el-button>
                    <el-button type="primary" @click.native="addApi()">确 定</el-button>
                </div>
            </el-dialog>
        </el-container>
    </el-container>
</template>
<script>
    import {
        getProjectApi,
        saveApiCategory,
        getCategory,
        saveApi,
        getApi,
        delApi,
        copyApi,
        setApiField,
        saveSort
    } from '@/api/apis'
    import {getInviteProject} from '@/api/project'
    import {userinfo} from '@/api/user'
    import TopBar from '@/components/common/TopBar'
    import ApiList from '@/components/common/ApiList'
    import Detail from '@/components/common/Detail'
    import Setting from '@/components/common/Setting'
    sessionStorage.setItem('setting', 'env');

    export default {
        name: 'Apis',
        data() {
            return {
                nav: [],
                name: '',
                tree: [],
                categoryDialogVisible: false,
                apiDialogVisible: false,
                copyApiDialogVisible: false,
                copyCategoryDialogVisible: false,
                form: {
                    name: ''
                },
                formLabelWidth: '80px',
                formApi: {
                    method: 'get',
                    name: '',
                    uri: '',
                    category: 0
                },
                categories: {},
                formCopy: {
                    name: '',
                    category: '',
                    id: ''
                },
                formCategoryCopy: {
                    name: '',
                    project: '',
                    id: ''
                },
                formEdit: {
                    id: 0,
                    name: '',
                    category: ''
                },
                editDialogVisible: false,
                handleClick: 'show',
                detailKey: 0,
                projectId: this.$route.params.id,
                userInfo: {},
                categoryTitle: '',
                apiDialogKey: 0,
                defaultKey: [],
                defaultCheck: 0,
                appVal: '',
                appOld: 0,
                isEdit: 0,
                roleId: 1,
            }
        },
        components: {
            TopBar, ApiList, Detail, Setting
        },
        created() {
            this.init()
        },
        watch: {
            appVal(val, oldVal) {
                if (val && oldVal) {
                    if (val != oldVal && this.isEdit > 3) {
                        this.appOld = oldVal;
                    }
                }
            }
        },
        methods: {
            init() {
                if (sessionStorage.getItem('apiType')) {
                    this.handleClick = sessionStorage.getItem('apiType');
                    if (this.handleClick == 'click') {
                        this.apiId = sessionStorage.getItem('apiId');
                        this.roleId = sessionStorage.getItem('roleId');
                        this.getTree(Number(sessionStorage.getItem('pid')));
                    } else {
                        this.getTree();
                    }
                } else {
                    this.getTree();
                }
                userinfo().then(rs => {
                    this.userInfo = rs.data;
                    this.roleId = this.userInfo.role_id;
                    sessionStorage.setItem('roleId', this.roleId);
                });
                this.getCategoryList()
                getInviteProject().then(rs => {
                    this.nav = rs.data
                });
            },
            changeDetail(apiId) {
                this.handleClick = 'click';
                this.apiId = apiId;
            },
            changeList(id) {
                if (id == 7) {
                    this.$router.push('/dashboard')
                } else {
                    this.$router.push('/project/' + id)
                }
            },
            changeHandle(name) {
                this.handleClick = name;
            },
            showList() {
                this.isEdit = 0;
                this.handleClick = 'show'
                sessionStorage.setItem('apiType', 'show');
            },
            setting() {
                this.isEdit = 0;
                this.handleClick = 'setting';
                sessionStorage.setItem('apiType', 'setting');
            },
            handleNodeClick(data) {
                this.appVal = data.id;
                if (!data.children && data.pid > 0) {
                    if (this.isEdit > 3) {
                        this.$confirm('表单未保存确定离开吗??', '提示', {
                            confirmButtonText: '确定',
                            cancelButtonText: '取消',
                            type: 'warning'
                        }).then(() => {
                            this.isEdit = 0;
                            this.handleClick = true;
                            this.apiId = data.id;
                            this.detailKey += 1;
                        }).catch(() => {
                            if (this.appOld > 0) {
                                this.$refs['myTree'].setCurrentKey(this.appOld);
                                this.appVal = this.appOld
                            }
                        });
                    } else {
                        this.handleClick = true;
                        this.apiId = data.id;
                        this.detailKey += 1;
                    }

                    sessionStorage.setItem('apiType', 'click');
                    sessionStorage.setItem('apiId', this.apiId);
                    sessionStorage.setItem('pid', data.pid);
                }
            },
            addSubmit() {
                if (this.form.id == 0) {
                    saveApiCategory({
                        project_id: this.$route.params.id,
                        name: this.form.name
                    }).then(() => {
                        this.$message({
                            type: 'success',
                            message: '添加成功'
                        })
                        this.getTree()
                        this.categoryDialogVisible = false
                    })
                } else {
                    setApiField({id: this.form.id, name: this.form.name}).then((rs) => {
                        this.$message('更新成功')
                        this.categoryDialogVisible = false;
                        this.getTree();
                    })
                }
            },
            showApiDialog(category) {
                this.getCategoryList();
                this.apiDialogVisible = true
                this.formApi.name = '';
                this.formApi.uri = '';
                this.formApi.category = category
                this.$nextTick(() => {
                    this.$refs.addApi.focus()
                })
            },
            showAddDialog() {
                this.categoryTitle = '添加分类';
                this.categoryDialogVisible = true
                this.form.id = 0;
                this.form.name = '';
                this.$nextTick(() => {
                    this.$refs.addCategory.focus()
                })
            },
            showEditDialog(data, pid) {
                this.editDialogVisible = true
                this.formEdit.name = data.label;
                this.formEdit.id = data.id
                this.formEdit.category = pid
            },
            showCategoryDialog(data) {
                this.categoryDialogVisible = true
                this.categoryTitle = '编辑分类';
                this.form.id = data.id;
                this.form.name = data.label;
            },
            showCopyApiDialog(data, pid) {
                this.copyApiDialogVisible = true
                this.formCopy.category = pid
                this.formCopy.name = 'copy' + data.label
                this.formCopy.id = data.id
            },
            showCopyCategoryDialog(data) {
                this.copyCategoryDialogVisible = true
                this.formCategoryCopy.project = Number(this.$route.params.id)
                this.formCategoryCopy.name = 'copy' + data.label
                this.formCategoryCopy.id = data.id
            },
            copy(type) {
                copyApi({
                    'project_id': (type > 0) ? this.formCategoryCopy.project : this.$route.params.id,
                    'source_id': (type > 0) ? this.formCategoryCopy.id : this.formCopy.id,
                    'pid': (type > 0) ? 0 : this.formCopy.category,
                    'name': (type > 0) ? this.formCategoryCopy.name : this.formCopy.name
                }).then((rs) => {
                    const msg = (type > 0) ? '复制分类成功' : '复制接口成功'
                    this.$message({
                        type: 'success',
                        message: msg
                    })
                    this.copyCategoryDialogVisible = false;
                    this.copyApiDialogVisible = false;
                    if (!type) {
                        this.apiId = Number(rs.data.msg);
                        this.getTree(this.formCopy.category);
                    } else {
                        this.getTree(this.formCategoryCopy.id);
                    }


                })
            },
            addApi() {
                saveApi({
                    project_id: this.$route.params.id,
                    name: this.formApi.name,
                    method: this.formApi.method,
                    pid: this.formApi.category,
                    uri: this.formApi.uri
                }).then((rs) => {
                    this.$message({
                        type: 'success',
                        message: '添加接口成功'
                    })
                    let pid = this.formApi.category;
                    this.apiDialogVisible = false;
                    this.apiId = Number(rs.data.msg);
                    this.getTree(pid);
                })
            },
            getTree(pid) {
                getProjectApi({id: this.$route.params.id}).then(rs => {
                    this.tree = rs.data
                    if (pid) {
                        this.defaultKey = [pid]
                        if (this.apiId) {
                            this.changeDetail(this.apiId);
                            this.$nextTick(() => {
                                this.$refs['myTree'].setCurrentKey(this.apiId);
                            });
                            this.detailKey++;
                        }
                    } else {
                        let kid = rs.data[0].id;
                        this.defaultKey = [kid];
                    }
                })
            },
            getCategoryList() {
                getCategory({id: this.$route.params.id}).then(rs => {
                    this.categories = rs.data
                })
            },
            del(id, pid) {
                this.$confirm('确定删除该接口吗?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    delApi({id: id}).then(() => {
                        this.$message.success('删除成功')
                        if (pid) {
                            this.getTree(pid);
                        } else {
                            this.getTree();
                        }
                    })
                }).catch(() => {
                });
            },
            editApiName() {
                setApiField({id: this.formEdit.id, name: this.formEdit.name, pid: this.formEdit.category}).then((rs) => {
                    this.$message('更新成功')
                    this.editDialogVisible = false;
                    this.getTree(this.formEdit.category);
                })
            },
            allowDrop(draggingNode, dropNode, type) {
                if (draggingNode.level === dropNode.level) {
                    if (draggingNode.parent.id === dropNode.parent.id) {
                        return type === "prev" || type === "next";
                    }
                } else {
                    return false;
                }
            },

            sortTree(draggingNode, dropNode, type, event) {
                let obj = {
                    aboveId: "",
                    arr: []
                };
                obj.aboveId = dropNode.parent.data.id;
                for (let item of dropNode.parent.childNodes) {
                    obj.arr.push(item.data.id);
                }

                obj = JSON.stringify(obj);
                saveSort(obj).then((rs) => {
                    console.log('已重新排序');
                })
            }
        }
    }
</script>
<style lang="scss">
    #box .el-tree-node__content {
        padding: 10px 0;
    }

    #box .el-tree-node.is-current > .el-tree-node__content {
        background-color: #1f2d3d !important;
        color: #409eff;
    }

    #box .el-tree-node__content:hover {
        background-color: #1f2d3d !important;
        color: #fff;
    }

    #box .el-checkbox__input.is-checked + .el-checkbox__label {
        color: black;
    }
    #box .el-tree {
        background-color: #333744;
        color: #fff;
        padding-top: 10px;
    }

    #box .el-tree-node__content {
        &:hover {
            background: #89c2f7;
        }
    }
    #box .el-tree-node:focus > .el-tree-node__content {
        background-color: #5daaf0;
    }

    .el-button--text {
        color: #fff
    }
</style>
<style scoped lang="scss">
    .el-checkbox__input.is-checked + .el-checkbox__label {
        color: black;
    }

    .el-button--text {
        color: #fff
    }

    .el-header {
        padding: 0px;
    }

    .el-dialog {
        width: 200px;
    }

    .custom-tree-node {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: space-between;
        font-size: 14px;
        padding-right: 8px;
    }

    .show-hide:hover :nth-child(2) {
        display: inline-block !important;
    }

    .show-hide {
        max-width: 210px;
    }


    .left-aside {
        background-color: #333744;
        overflow-y: hidden;
    }

    .myscrollbar{
        height: calc(100vh - 100px);
    }
    .myscrollbar>>>.el-scrollbar__wrap{
        overflow-x: hidden;
    }

    .container {
        position: absolute;
        top: 0px;
        bottom: 0px;
        height: calc(100vh);
        width: 100%;

        .main {
            display: -webkit-box;
            display: -webkit-flex;
            display: -ms-flexbox;
            display: flex;
            position: absolute;
            top: 50px;
            bottom: 0px;
            overflow: hidden;
        }
        .menu-toggle {
            background: #4A5064;
            text-align: center;
            color: white;
            height: 40px;
            line-height: 40px;
            font-size: 13px;
        }
        .content-container {
            background: #fff;
            flex: 1;
            overflow-y: auto;
            padding: 10px;
            padding-bottom: 1px;

            .content-wrapper {
                background-color: #fff;
                box-sizing: border-box;
            }
        }
    }
</style>
