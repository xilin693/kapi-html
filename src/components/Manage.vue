<template>
    <el-tabs type="border-card">
        <el-tab-pane label="用户审核">
            <Audit></Audit>
        </el-tab-pane>
        <el-tab-pane label="项目组管理">
            <Group></Group>
        </el-tab-pane>
    </el-tabs>
</template>
<script>
    import Group from '@/components/common/Group';
    import Audit from '@/components/common/Audit';
    export default {
        name: 'Manage',
        data() {
            return {
            }
        },
        created() {
            this.init()
        },
        components: {Group, Audit},
        methods: {
            init() {
            }
        }
    }
</script>