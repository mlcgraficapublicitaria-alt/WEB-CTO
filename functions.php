<?php
/**
 * CTO Blocksy Child theme functions.
 */

if (! defined('ABSPATH')) {
    exit;
}

add_action('wp_enqueue_scripts', function () {
    wp_enqueue_style(
        'blocksy-child-cto-style',
        get_stylesheet_uri(),
        ['ct-main-styles'],
        filemtime(get_stylesheet_directory() . '/style.css')
    );
});

add_action('wp_head', function () {
    ?>
    <style id="cto-header-overrides">
      body #header.ct-header [data-device="desktop"] [data-row="middle"] {
        --height: 132px !important;
        background: #ffffff !important;
        border-bottom: 1px solid #dbe3e8 !important;
      }

      body #header.ct-header [data-device="desktop"] .ct-container {
        width: min(100%, 1920px) !important;
        max-width: none !important;
        padding-inline: 72px 28px !important;
      }

      body #header.ct-header [data-device="desktop"] [data-column="start"] {
        min-width: 230px !important;
      }

      body #header.ct-header [data-device="desktop"] [data-column="end"] [data-items="primary"] {
        align-items: center !important;
        gap: 14px !important;
      }

      body #header.ct-header .site-title-container,
      body #header.ct-header .ct-header-search,
      body.home .hero-section[data-type] {
        display: none !important;
      }

      body #header.ct-header .site-logo-container img {
        width: 178px !important;
        max-width: 178px !important;
        height: auto !important;
      }

      body #header-menu-1 .menu {
        align-items: center !important;
        display: flex !important;
        gap: 8px !important;
      }

      body #header-menu-1 .menu > li {
        display: flex !important;
        margin: 0 !important;
      }

      body #header-menu-1 .menu > li > .ct-menu-link {
        min-height: 44px !important;
        padding: 0 13px !important;
        color: #3a4f66 !important;
        --theme-font-size: 13px !important;
        font-size: 13px !important;
        font-weight: 800 !important;
        letter-spacing: 0 !important;
        text-transform: uppercase !important;
      }

      body #header-menu-1 .menu > li > .ct-menu-link *,
      body #header-menu-1 .menu > li > .ct-menu-link span {
        font-size: 13px !important;
      }

      body #header-menu-1 .menu > li.page-item-73 > .ct-menu-link,
      body #header-menu-1 .menu > li.page-item-70 > .ct-menu-link,
      body #header-menu-1 .menu > li.menu-item-object-page > a[href*="/formacion/"],
      body #header-menu-1 .menu > li.menu-item-object-page > a[href*="/indiba-maquinas/"] {
        min-width: 116px !important;
        justify-content: center !important;
        border-radius: 3px !important;
        background: #3a4f66 !important;
        color: #ffffff !important;
        letter-spacing: 0.08em !important;
      }

      body #header-menu-1 .menu > li.page-item-70 > .ct-menu-link,
      body #header-menu-1 .menu > li.menu-item-object-page > a[href*="/indiba-maquinas/"] {
        min-width: 152px !important;
      }

      body #header.ct-header .boton-formacion {
        display: inline-flex !important;
        align-items: center !important;
        justify-content: center !important;
        min-height: 44px !important;
        min-width: 126px !important;
        padding: 0 18px !important;
        border-radius: 3px !important;
        border-color: #3a4f66 !important;
        background: #3a4f66 !important;
        color: #ffffff !important;
        font-size: 13px !important;
        font-weight: 800 !important;
        letter-spacing: 0.08em !important;
        line-height: 1 !important;
        text-transform: uppercase !important;
      }

      body #header.ct-header .boton-formacion + .boton-formacion {
        min-width: 166px !important;
      }

      body #header.ct-header .ct-header-socials {
        --theme-icon-size: 22px !important;
        gap: 12px !important;
        margin-left: 6px !important;
      }

      body #header.ct-header .ct-header-socials .ct-icon-container,
      body #header.ct-header .ct-header-socials a {
        width: 22px !important;
        height: 22px !important;
      }

      body #header.ct-header .ct-header-socials svg {
        width: 22px !important;
        height: 22px !important;
      }

      @media (max-width: 1340px) {
        body #header.ct-header .site-logo-container img {
          width: 150px !important;
          max-width: 150px !important;
        }

        body #header.ct-header [data-device="desktop"] [data-column="start"] {
          min-width: 190px !important;
        }

        body #header-menu-1 .menu {
          gap: 4px !important;
        }

        body #header-menu-1 .menu > li > .ct-menu-link {
          padding-inline: 8px !important;
          --theme-font-size: 12px !important;
          font-size: 12px !important;
        }

        body #header.ct-header .boton-formacion {
          min-height: 42px !important;
          min-width: 112px !important;
          padding-inline: 14px !important;
          font-size: 12px !important;
        }

        body #header.ct-header .boton-formacion + .boton-formacion {
          min-width: 150px !important;
        }

        body #header.ct-header .ct-header-socials {
          --theme-icon-size: 20px !important;
        }

        body #header.ct-header .ct-header-socials .ct-icon-container,
        body #header.ct-header .ct-header-socials a,
        body #header.ct-header .ct-header-socials svg {
          width: 20px !important;
          height: 20px !important;
        }
      }

      @media (max-width: 999.98px) {
        body #header.ct-header .site-logo-container img {
          width: 112px !important;
          max-width: 112px !important;
        }
      }
    </style>
    <?php
}, 999);
