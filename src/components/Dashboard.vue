<template>
    <ProjectList :list="list" :listName="listName"></ProjectList>
</template>

<script>
    import {getOwnerProject} from '@/api/project';
    import ProjectList from '@/components/common/ProjectList'

    export default {
        data() {
            return {
                list: [],
                listName: '个人空间'
            }
        },
        components: {
            ProjectList
        },
        created() {
            this.init()
        },
        methods: {
            init() {
                getOwnerProject().then(res => {
                    this.list = res.data
                })
            }
        }
    }
</script>
