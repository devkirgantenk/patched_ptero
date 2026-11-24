# patched_ptero

Image Docker **Java kustom untuk Pterodactyl Panel** yang sudah ter-patch penuh terhadap
**CVE-2026-114938 (a.k.a. "Java4Shell")**.

Image resmi Pterodactyl (`ghcr.io/pterodactyl/yolks`) saat ini hanya menerapkan *flag mitigasi*,
sedangkan image di repositori ini dibangun di atas base image yang **sudah terbukti dipatch**:

| Base | Distribusi |
|---|---|
| `mcr.microsoft.com/openjdk/jdk:17-ubuntu` | Microsoft OpenJDK |
| `mcr.microsoft.com/openjdk/jdk:21-ubuntu` | Microsoft OpenJDK |
| `mcr.microsoft.com/openjdk/jdk:25-ubuntu` | Microsoft OpenJDK |
| `eclipse-temurin:8-jre-jammy` | Eclipse Temurin |
| `eclipse-temurin:11-jre-jammy` | Eclipse Temurin |
| `eclipse-temurin:16-jre` | Eclipse Temurin |

Dikelola oleh **devkirgantenk**. Build otomatis via GitHub Actions dan dipush ke
**GitHub Container Registry (GHCR)**.

---

## Tag yang tersedia

| Tag | Base image | Arsitektur |
|---|---|---|
| `ghcr.io/devkirgantenk/patched_ptero:java_8` | eclipse-temurin:8-jre-jammy | amd64, arm64 |
| `ghcr.io/devkirgantenk/patched_ptero:java_11` | eclipse-temurin:11-jre-jammy | amd64, arm64 |
| `ghcr.io/devkirgantenk/patched_ptero:java_16` | eclipse-temurin:16-jdk | amd64, arm64 |
| `ghcr.io/devkirgantenk/patched_ptero:java_17` | mcr.microsoft.com/openjdk/jdk:17-ubuntu | amd64, arm64 |
| `ghcr.io/devkirgantenk/patched_ptero:java_21` | mcr.microsoft.com/openjdk/jdk:21-ubuntu | amd64, arm64 |
| `ghcr.io/devkirgantenk/patched_ptero:java_25` | mcr.microsoft.com/openjdk/jdk:25-ubuntu | amd64, arm64 |

---

## Cara pakai di Pterodactyl Panel

1. **Buka Egg** yang dipakai server kamu (Nginx Admin → Eggs, atau langsung edit egg-nya),
   lalu pada bagian **Docker Images** (atau variabel `Docker Image Image`) ganti/confirm image:

   ```
   ghcr.io/devkirgantenk/patched_ptero:java_21
   ```

   Contoh untuk Minecraft Paper 1.20+ (butuh Java 21):

   ```yaml
   docker_images:
     Java 21 (patched):
       image: ghcr.io/devkirgantenk/patched_ptero:java_21
   ```

2. **Atau per-server**: di Panel → server → **Startup** → **Docker Image**, pilih/masukkan
   tag image di atas.

3. **Rebuild server** (Panel → Settings → Rebuild Server) supaya Wings menarik image baru.

Package GHCR ini **publik**, jadi Wings tidak perlu `docker login` untuk menariknya.

> Image ini drop-in replacement untuk egg berbasis yolks resmi: entrypoint-nya kompatibel
> (export `INTERNAL_IP`, substitusi variabel `{{...}}` pada `STARTUP`), user non-root
> `container` (UID 1000) sudah disiapkan.

---

## Build otomatis (GitHub Actions)

Workflow: [`.github/workflows/build.yml`](.github/workflows/build.yml)

- **Trigger**: `push` ke `main`, `workflow_dispatch` (manual), dan **jadwal mingguan**
  (`cron: 0 3 * * 0`, setiap Minggu 03:00 UTC) agar base image selalu fresh.
- **Multi-arch**: `linux/amd64` + `linux/arm64` (buildx + QEMU).
- **Registry**: login ke `ghcr.io` memakai built-in `secrets.GITHUB_TOKEN`.
- **Verifikasi patch (wajib lulus)**: untuk Java **17, 21, dan 25**, workflow menjalankan
  container yang baru di-push lalu mengecek `java -version`. Versi ter-patch ditandai
  komponen tambahan `.1` (contoh: `21.0.13.1`). Jika output **tidak** mengandung `.1`,
  workflow **gagal (exit 1)** dengan pesan bahwa image belum dipatch.

Memicu build manual:

```bash
gh workflow run build --repo devkirgantenk/patched_ptero
```

---

## Lisensi

MIT — gunakan dengan risiko sendiri. Image ini bukan produk resmi Pterodactyl;
base image berasal dari Microsoft OpenJDK dan Eclipse Temurin.
