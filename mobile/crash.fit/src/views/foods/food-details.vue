<template>
  <div :class="{desktop: isDesktop }">
    <div class="row pad">
    <q-input type="text" v-model="name" :float-label="$t('name')" />
    </div>
    <q-tabs v-model="tab">
        <!-- Tabs - notice slot="title" -->
        <q-tab slot="title" name="tab-1" :label="$t('nutrients')" />
        <q-tab slot="title" name="tab-2" :label="$t('portions')" />
        <!-- Targets -->
        <q-scroll-area style="height: 66vh;">
          <q-tab-pane name="tab-1">
            
              <div class="row">
                <div class="col-2" style="padding-top: 20px">{{ $t("amount") }}/</div>
                <div class="col"><q-select v-model="nutrientPortion" :options="nutrientPortions" @change="changeNutrientPortion" /></div>
              </div>
              <template v-for="(group,index) in nutrientGroups">
                <div :key="index">
                  <div class="row" @click="toggleGroup(group)">
                    <h6>
                      <i v-if="selectedGroup != group" class="fa fa-chevron-down"></i>
                      <i v-if="selectedGroup == group" class="fa fa-chevron-up"></i>
                      {{ $t(group.id) }}
                    </h6>
                  </div>
                  <div v-if="selectedGroup == group">
                    <div class="row" v-for="(nutrient,index_n) in nutrientsGrouped[group.id]" :key="index_n">
                        <template v-if="!nutrient.computed">
                            <div class="col col-sm-3 col-lg-2"><q-input type="number" v-model="nutrients[nutrient.id]" :float-label="nutrient.name" /></div>
                            <div class="col unit">{{ formatUnit(nutrient.unit)}}</div>
                        </template>
                    </div>
                  </div>
                </div>
              </template>
            
          </q-tab-pane>
          <q-tab-pane name="tab-2">
            <div class="row" v-for="(portion,index) in portions" :key="index">
              <div class="col col-8"><q-input type="text" v-model="portion.name" :float-label="$t('name')" /></div>
              <div class="col col-3"><q-input type="number" v-model="portion.weight" :float-label="$t('weight')" /></div>
              <div class="col col-1"><q-btn round small color="primary" icon="fa-trash" @click="removePortion(index)"></q-btn></div>
            </div>
            <div class="row">
              <q-btn round small color="primary" icon="fa-plus" @click="addPortion"></q-btn>
            </div>
          </q-tab-pane>
        </q-scroll-area>
    </q-tabs>
    <div class="row pad buttons">
      <q-btn @click="cancel">{{ $t('cancel') }}</q-btn>
      <q-btn color="primary" @click="save">{{ $t('save') }}</q-btn>
    </div>
  </div>
</template>

<script src="./food-details.js">
</script>

<style lang="stylus" scoped>


.q-tab-pane { height: 66vh;}

.desktop .q-tab-pane { height: 70vh;}
.desktop .q-scrollarea { height: 100%;}

.unit{ padding-top: 30px;}
</style>
