<template>
    <div class="icons-container">
        <el-tabs type="border-card">
            <el-tab-pane :label="listName">
                <div class="grid">
                    <div v-for="(item,index) in list" :key="index">
                        <div class="icon-item" :style="{color:item.icon_color}"  @click="jumpTo(item.id)">
                            <i :class="'el-icon-' + item.icon"/>
                            <span class="ui-title">{{ item.name }}</span>
                        </div>
                    </div>
                </div>
            </el-tab-pane>
        </el-tabs>
    </div>
</template>

<script>
    export default {
        name: 'ProjectList',
        props: ['list', 'listName'],
        methods: {
            jumpTo(id) {
                if (typeof(id) == 'string') {
                    this.$router.push('/' + id);
                } else {
                    this.$router.push('/apis/' + id)
                }
            }
        }
    }
</script>

<style lang="scss" scoped>
    .icons-container {
        margin: 10px 20px 0;
        overflow: hidden;

        .grid {
            position: relative;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
        }

        .icon-item {
            margin: 20px;
            text-align: center;
            width: 100px;
            float: left;
            font-size: 50px;
            color: #3d546f;
            cursor: pointer;
        }

        .ui-title {
            font-size: 16px;
            color: #3d546f;
        }

        span {
            display: block;
            font-size: 16px;
            margin-top: 10px;
        }

        .disabled {
            pointer-events: none;
        }
    }
</style>
