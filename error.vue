<template>
  <div class="flex flex-col justify-center items-center h-screen space-y-2">
    <NuxtLink prefetch to="/">
      <NuxtImg src="/favicon.webp" class="shadow rounded mb-6" alt="abstract drawing boy" width="250" height="250" />
    </NuxtLink>

    <h1 class="text-4xl font-bold text-[#EF4135]">{{ $t("error.lost") }}</h1>
    <h2 class="text-4xl font-bold text-[#0055A4]">{{ $t("error.path") }}</h2>

    <NuxtLink prefetch to="/" class="no-underline px-1.5 py-1.5 border border-zinc-700 rounded">{{ $t("error.home") }}</NuxtLink>
  </div>
</template>
