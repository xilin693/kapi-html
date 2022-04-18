<template>
   <ProjectSet></ProjectSet>
</template>
<script>
import ProjectSet from '@/components/common/ProjectSet';
export default {
  name: 'item',
  data() {
    return {}
  },
  props: ['projectId', 'accountId'],
  components: {ProjectSet}
}

</script>