<template>
    <div class="login-box">
        <div class="login-logo">
            <a href="/"><b>fitlog</b>.fi</a>
        </div>
        <div class="login-box-body">
            <div class="form-group has-feedback">
                <label>{{ $t("username") }}/{{ $t("email") }}</label>
                <input type="text" class="form-control" v-model="username">
            </div>
            <div class="form-group has-feedback">
                <label>{{ $t("password") }}</label>
                <input type="password" class="form-control" v-model="password" @keyup.enter="login">
            </div>
            <div class="row">
                <div class="col-xs-4 col-xs-offset-8">
                    <button class="btn btn-primary btn-block btn-flat" @click="login">{{ $t("login") }}</button>
                </div>
            </div>
            <div class="social-auth-links text-center">
                <p>- {{ $t("or") }} -</p>
                <a class="btn btn-block btn-social btn-facebook btn-flat" @click="loginFacebook">
                    <i class="fab fa-facebook"></i> {{ $t("useFacebook") }}
                </a>
                <a class="btn btn-block btn-social btn-google btn-flat" @click="loginGoogle">
                    <i class="fab fa-google-plus"></i> {{ $t("useGoogle") }}
                </a>
            </div>
            <router-link :to="{ name: 'register' }" class="text-center">{{ $t("register") }}</router-link>
        </div>
    </div>
</template>

<script>
    import constants from '../store/constants'
    import api from '../api'

export default {
    data ()
    {
        return {
            username: null,
            password: null,
            client: ''
        }
    },
    components: {},
    methods: {
        login() {
            var self = this;
            var data = {
                username: this.username,
                password: this.password,
                client: this.client
            };
            api.login(data).then((response) => {
                self.$store.dispatch(constants.STORE_TOKENS, {
                    client: response.client,
                    refreshToken: response.refreshToken,
                    accessToken: response.accessToken,
                    success() {
                        window.location = '/';
                    },
                    failure() {
                        toaster(self.$t('failed'));
                    }
                });
                
            });
        },
        loginGoogle() {
            //dialog = window.open(api.baseUrl+'users/external-login/?provider=Google','_blank','width=400,height=600');
            window.location = api.baseUrl + 'users/external-login/?provider=Google&client=' + this.client;
        },
        loginFacebook() {
            //this.dialog = window.open(api.baseUrl + 'users/external-login/?provider=Facebook', '_blank', 'width=400,height=600');
            window.location = api.baseUrl + 'users/external-login/?provider=Facebook&client=' + this.client;
        }
    },
    created() {
        this.client = this.$route.params.client || 'web';
        this.$store.commit(constants.LOADING_DONE);
    },
    mounted() {
        var self = this;
        window.closeDialog = () => {
            console.log(self.dialog);
            self.dialog.close();
            window.location = '/';
        };
    }
}
</script>

<style scoped>
</style>