<!--
  Matomo - free/libre analytics platform
  @link https://matomo.org
  @license http://www.gnu.org/licenses/gpl-3.0.html GPL v3 or later
-->

<template>
  <div
    :title="translate('Feedback_RateFeatureTitle', $sanitize(title))"
    class="ratefeature"
  >
    <div
      class="iconContainer"
      v-on:mouseenter="expanded = true"
      v-on:mouseleave="expanded = false"
    >
      <img
        v-on:click="likeFeature();"
        class="like-icon"
        src="plugins/Feedback/vue/src/RateFeature/thumbs-up.png"
      />
      <img
        v-on:click="dislikeFeature();"
        class="dislike-icon"
        src="plugins/Feedback/vue/src/RateFeature/thumbs-down.png"
      />
    </div>
    <MatomoDialog
      v-model="showFeedbackForm"
      @yes="sendFeedback()"
      @validation = "sendFeedback()"
    >
      <div
        class="ui-confirm ratefeatureDialog"
      >
        <div
          v-if="like"
        >
          <h2 v-if="title" >{{ translate('Feedback_RateFeatureLeaveMessageLikeNamedFeature',
          title) }}</h2>
          <h2 v-if="!title" >{{ translate('Feedback_RateFeatureLeaveMessageLike') }}</h2>
          <br />
          <div class="row">
            <div style="text-align:left; margin-top: 16px">
              <label for="useful" class="ratelabel">
                <input type="radio" id="useful" value="useful" v-model="likeReason"
                       class="rateradio">
                {{ translate('Feedback_RateFeatureUsefulInfo') }}
              </label>
              <br />
              <label for="easy" class="ratelabel">
                <input type="radio" id="easy" value="easy" v-model="likeReason" class="rateradio">
                {{ translate('Feedback_RateFeatureEasyToUse') }}
              </label>
              <br />
              <label for="configurable" class="ratelabel">
                <input type="radio" id="configurable" value="configurable" v-model="likeReason"
                       class="rateradio">
                {{ translate('Feedback_RateFeatureConfigurable') }}
              </label>
              <br />
              <label for="likeother" class="ratelabel">
                <input type="radio" id="likeother" value="likeother" v-model="likeReason"
                       class="rateradio">
                {{ translate('Feedback_RateFeatureOtherReason') }}
              </label>
            </div>
          </div>

        </div>
        <div
          v-if="!like"
        >
          <h2 v-if="title">{{ translate('Feedback_RateFeatureLeaveMessageDislikeNamedFeature',
            title) }}</h2>
          <h2 v-if="!title">{{ translate('Feedback_RateFeatureLeaveMessageDislike') }}</h2>
          <br />
          <div class="row">
            <div style="text-align:left">
              <label for="missingfeatures" class="ratelabel">
                <input type="radio" id="missingfeatures" value="missingfeatures"
                       v-model="dislikeReason" class="rateradio">
                {{ translate('Feedback_RateFeatureDislikeAddMissingFeatures') }}
              </label>
              <br />
              <label for="makeeasier" class="ratelabel">
                <input type="radio" id="makeeasier" value="makeeasier" v-model="dislikeReason"
                       class="rateradio">
                {{ translate('Feedback_RateFeatureDislikeMakeEasier') }}
              </label>
              <br />
              <label for="speedup" class="ratelabel">
                <input type="radio" id="speedup" value="speedup" v-model="dislikeReason"
                       class="rateradio">
                {{ translate('Feedback_RateFeatureDislikeSpeedUp') }}
              </label>
              <br />
              <label for="fixbugs" class="ratelabel">
                <input type="radio" id="fixbugs" value="fixbugs" v-model="dislikeReason"
                       class="rateradio">
                {{ translate('Feedback_RateFeatureDislikeFixBugs') }}
              </label>
              <br />
              <label for="dislikeother" class="ratelabel">
                <input type="radio" id="dislikeother" value="dislikeother" v-model="dislikeReason"
                       class="rateradio">
                {{ translate('Feedback_RateFeatureOtherReason') }}
              </label>
              <br />
            </div>
          </div>

        </div>

        <div v-if="likeReason || dislikeReason" class="messageContainer" style="text-align:left">

          <p v-if="likeReason && likeReason == 'useful'"
             v-html="translate('Feedback_RateFeatureLeaveMessageLikeExtraUseful')">
          </p>
          <p v-if="likeReason && likeReason == 'easy'"
             v-html="translate('Feedback_RateFeatureLeaveMessageLikeExtraEasy')">
          </p>
          <p v-if="likeReason && likeReason == 'configurable'"
             v-html="translate('Feedback_RateFeatureLeaveMessageLikeExtraConfigurable')">
          </p>
          <p v-if="likeReason && likeReason == 'likeother'"
             v-html="translate('Feedback_RateFeatureLeaveMessageLikeExtra')">
          </p>

          <p v-if="dislikeReason && dislikeReason == 'missingfeatures'"
             v-html="translate('Feedback_RateFeatureLeaveMessageDislikeExtraMissing')">
          </p>
          <p v-if="dislikeReason && dislikeReason == 'makeeasier'"
             v-html="translate('Feedback_RateFeatureLeaveMessageDislikeExtraEasier')">
          </p>
          <p v-if="dislikeReason && dislikeReason == 'fixbugs'"
             v-html="translate('Feedback_RateFeatureLeaveMessageDislikeExtraBugs')">
          </p>
          <p v-if="dislikeReason && dislikeReason == 'speedup'"
             v-html="translate('Feedback_RateFeatureLeaveMessageDislikeExtraSpeed')">
          </p>
          <p v-if="dislikeReason && dislikeReason == 'dislikeother'"
             v-html="translate('Feedback_RateFeatureLeaveMessageDislikeExtra')">
          </p>

          <div class="error-text" v-if="errorMessage">{{ errorMessage }}</div>
          <textarea ref="feedbackText" class="materialize-textarea" id="feedbacktext"
                    :class="{'has-error':errorMessage}"
                    v-model="feedbackMessage"/>
          <p v-if="likeReason || dislikeReason"
            v-html="translate('Feedback_Policy',`
            <a rel='nofollow' href='https://matomo.org/privacy-policy/' target='_blank'>`,'</a>')">
          </p>
        </div>

        <input
          class="btn"
          type="button"
          role="validation"
          :title="translate('Feedback_RateFeatureSendFeedbackInformation')"
          :value="translate('Feedback_SendFeedback')"
        />

        <input
          type="button"
          role="cancel"
          :value="translate('General_Cancel')"
        />
      </div>
    </MatomoDialog>

    <MatomoDialog
      v-model="ratingDone"
    >
      <div
        class="ui-confirm ratefeatureDialog"
      >
        <h2 v-html="translate('Feedback_ThankYouHeart',`<i class='icon-heart red-text'></i>`)"></h2>
        <div
          v-if="like"
        >
          <ReviewLinks/>
        </div>
        <p v-if="!like">{{ translate('Feedback_AppreciateFeedback') }}</p>
        <input
          type="button"
          :value="translate('General_Close')"
          role="yes"
        />
      </div>
    </MatomoDialog>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import { MatomoDialog, AjaxHelper } from 'CoreHome';
import ReviewLinks from '../ReviewLinks/ReviewLinks.vue';

const { $ } = window;

export default defineComponent({
  props: {
    title: String,
  },
  components: {
    MatomoDialog,
    ReviewLinks,
  },
  data() {
    return {
      like: false,
      likeReason: null,
      dislikeReason: null,
      ratingDone: false,
      expanded: false,
      showFeedbackForm: false,
      feedbackMessage: '',
      errorMessage: null,
    };
  },
  watch: {
    likeReason: 'doFocusInput',
    dislikeReason: 'doFocusInput',
  },
  methods: {
    dislikeFeature() {
      this.ratingDone = false;
      this.like = false;
      this.showFeedbackForm = true;
      this.errorMessage = null;
      this.likeReason = null;
      this.dislikeReason = null;
      this.feedbackMessage = '';
    },
    likeFeature() {
      this.ratingDone = false;
      this.like = true;
      this.showFeedbackForm = true;
      this.errorMessage = null;
      this.likeReason = null;
      this.dislikeReason = null;
      this.feedbackMessage = '';
    },
    doFocusInput() {
      this.$nextTick(() => {
        this.focusInput();
      });
    },
    focusInput() {
      if (this.$refs.feedbackText != null) {
        this.$refs.feedbackText.focus();
      }
    },
    async sendFeedback() {
      this.errorMessage = null;
      const res = await AjaxHelper.fetch({
        method: 'Feedback.sendFeedbackForFeature',
        featureName: this.title,
        like: this.like ? '1' : '0',
        choice: this.like ? this.likeReason : this.dislikeReason,
        message: this.feedbackMessage,
      });

      if (res.value === 'success') {
        $('.modal').modal('close');
        this.ratingDone = true;
        this.feedbackMessage = '';
      } else {
        this.errorMessage = res.value;
      }
    },
  },
});
</script>
