<template>
    <ProjectList :list="list" :listName="listName"></ProjectList>
</template>

<script>
import { getGroupProject } from '@/api/project'
import ProjectList from '@/components/common/ProjectList'
import { getGroupName } from '@/utils/auth'

export default {
    name: 'Project',
    data() {
        return {
            list: [],
            listName: getGroupName(this.$route.params.id),
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
            getGroupProject({ id: this.$route.params.id }).then(res => {
                this.list = res.data
            })
        }
    }
}
</script>
