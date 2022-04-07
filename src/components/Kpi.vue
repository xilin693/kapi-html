<template>
    <div class="icon-container" v-if="userId">
        <Exam edit="my" :userId="userId" :realname="realname"></Exam>
    </div>
</template>
<script>
    import {userinfo} from '@/api/user';
    import Exam from '@/components/common/Exam';
    export default {
        data() {
            return {
                userId:0,
                realname: '',
            }
        },
        created() {
            userinfo().then((rs) => {
                this.userId = rs.data.id;
                this.realname = rs.data.realname;
            });
        },
        components: {Exam}
    }
</script>
