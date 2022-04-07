<template>
    <div class="icons-container">
        <el-tabs type="border-card">
            <el-tab-pane label="数据导入">
                <DataImport></DataImport>
            </el-tab-pane>
            <el-tab-pane label="数据导出">
                <DataExport></DataExport>
            </el-tab-pane>
        </el-tabs>
    </div>
</template>
<script>
    import DataImport from '@/components/common/DataImport';
    import DataExport from '@/components/common/DataExport';
    export default {
        name: 'Setting',
        components: {DataExport, DataImport},
    }
</script>