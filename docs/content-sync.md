# Publicacion automatica de contenido

Este flujo sirve para crear o actualizar paginas y entradas de WordPress desde la copia local hacia produccion, sin rehacerlas a mano.

## Requisitos

- Ejecutar desde el `Site shell` de LocalWP.
- Tener disponibles `wp`, `php` y `curl`.
- Crear una **Application Password** en el WordPress de produccion para un usuario con permisos de edicion.

## Variables necesarias

Usa estas variables de entorno:

```bash
export PROD_WP_BASE_URL="https://holisticaysalud.es"
export PROD_WP_USERNAME="admin"
export PROD_WP_APP_PASSWORD="xxxx xxxx xxxx xxxx xxxx xxxx"
```

Tambien puedes copiar `.env.publish.example` como referencia.

## Uso

```bash
./scripts/publish-content.sh <slug> [page|post] [publish|draft|private|pending]
```

Ejemplos:

```bash
./scripts/publish-content.sh osteopatia-estructural page publish
./scripts/publish-content.sh noticia-junio post draft
```

## Que sincroniza

- titulo
- contenido
- extracto
- slug
- estado
- plantilla de pagina si existe en `_wp_page_template`

## Que no sincroniza todavia

- imagen destacada
- menus
- metadatos SEO
- datos especificos de Elementor o plugins complejos
- relaciones avanzadas entre entradas

## Siguiente iteracion recomendada

- sincronizar imagen destacada
- copiar metadatos de Elementor cuando haga falta
- publicar por lote desde una lista de slugs
