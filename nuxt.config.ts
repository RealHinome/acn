import { isDevelopment } from "std-env";

export default defineNuxtConfig({
  app: {
    keepalive: true,
    head: {
      charset: "utf-8",
      viewport: "width=device-width,initial-scale=1",
      title: "ACN",
      htmlAttrs: {
        lang: "en",
      },
      meta: [
        { property: "og:type", content: "website" },
        { property: "og:site_name", content: "ACN" },
        { property: "og:title", content: "ACN" },
        {
          name: "og:description",
          content: "Personal website referencing all my projects",
        },
        { name: "robots", content: "index, follow" },
        {
          name: "description",
          content: "Personal website referencing all my projects",
        },
      ],
      bodyAttrs: {
        class: "bg-zinc-100 text-dark",
      },
    },
  },

  ssr: true,
  components: true,
  sourcemap: isDevelopment,

  modules: [
    "@nuxt/image",
    "@nuxtjs/tailwindcss",
    [
      "@nuxtjs/i18n",
      {
        defaultLocale: "en",
        strategy: "prefix_and_default",
        lazy: false,
        langDir: "locales",
        detectBrowserLanguage: {
          useCookie: true,
          cookieKey: "locale",
          redirectOn: "root",
          fallbackLocale: "en",
          alwaysRedirect: true,
        },
        locales: [
          {
            code: "en",
            iso: "en",
            file: "en.json",
            name: "English",
          },
          {
            code: "fr",
            iso: "fr",
            file: "fr.json",
            name: "Français",
          },
        ],
        baseUrl: "https://acn.pages.dev",
      },
    ],
  ],

  devtools: { enabled: true },
  postcss: {
    plugins: {
      tailwindcss: {},
      autoprefixer: {},
    },
  },

  routeRules: {
    // Deactivate JavaScript.
    "/fr/*": { experimentalNoScripts: true },
    "/en/*": { experimentalNoScripts: true },
  },

  features: {
    inlineStyles: true,
  },

  experimental: {
    headNext: true,
    payloadExtraction: false,
    renderJsonPayloads: true,
    viewTransition: true,
  },

  vue: {
    defineModel: true,
    propsDestructure: true,
  },
});
