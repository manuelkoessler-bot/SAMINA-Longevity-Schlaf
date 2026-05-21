#!/bin/bash
set -e
cd "$(dirname "$0")"

BODY=$(awk 'BEGIN{fm=0} /^---[[:space:]]*$/{fm++; next} fm<2{next} {print}' samina-longevity-blog.md \
  | npx -y -q marked \
  | sed -E 's|<(h[1-6])>(.*) \{#([a-z0-9_-]+)\}</h[1-6]>|<\1 id="\3">\2</\1>|g')

cat > samina-longevity-blog.html <<'HTML_HEAD'
<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Longevity beginnt im Schlaf - SAMINA Vorschau</title>
<style>
  :root{
    --green:#2d5a3d;
    --green-mid:#4a7c5e;
    --green-light:#7cba99;
    --cream:#f6f4ef;
    --cream-dark:#ebe6da;
    --ink:#1a1a1a;
    --mute:#666;
    --light-border:#e4e0d3;
  }
  *{box-sizing:border-box}
  html{scroll-behavior:smooth}
  body{margin:0;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Helvetica,Arial,sans-serif;color:var(--ink);background:#fff;line-height:1.7;}
  .container{max-width:780px;margin:0 auto;padding:0 24px 80px;}

  /* Fake SAMINA Site Nav (Preview) */
  .site-nav{position:absolute;top:0;left:0;right:0;z-index:10;display:flex;align-items:center;justify-content:space-between;padding:18px 40px;color:#fff;font-size:0.95rem;pointer-events:none;}
  .site-nav .logo{background:var(--green);color:#fff;font-weight:700;letter-spacing:0.04em;padding:6px 16px;font-size:1.4rem;}
  .site-nav .nav-items{display:flex;gap:2.5rem;align-items:center;}
  .site-nav .nav-items span{color:#fff;text-shadow:0 1px 4px rgba(0,0,0,0.4);}
  .site-nav .nav-kontakt{border:1px solid #fff;padding:8px 22px;border-radius:4px;}

  /* Hero: full-bleed */
  figure.hero{position:relative;margin:0;width:100%;height:62vh;min-height:420px;max-height:680px;overflow:hidden;}
  figure.hero img{width:100%;height:100%;object-fit:cover;display:block;}

  /* Breadcrumb (below hero) */
  .breadcrumb{font-size:0.9rem;color:var(--mute);padding:36px 0 18px;display:block;}
  .breadcrumb a{color:var(--mute);text-decoration:none;}
  .breadcrumb a:hover{color:var(--green);text-decoration:underline;}

  /* Meta + H1 */
  .post-meta{font-size:0.95rem;color:var(--mute);margin:0 0 2rem;}
  .post-meta strong{color:var(--ink);}
  h1{font-family:Georgia,"Times New Roman",serif;font-size:3rem;line-height:1.15;font-weight:700;margin:0 0 2rem;letter-spacing:-0.015em;color:var(--ink);}

  /* Author Box */
  .author-box{display:flex;align-items:center;gap:1rem;background:var(--cream);padding:1rem 1.25rem;border-radius:12px;margin:0 0 2.5rem;border:1px solid var(--light-border);}
  .author-box img{flex:0 0 64px;width:64px;height:64px;border-radius:50%;object-fit:cover;}
  .author-box .name{margin:0 0 0.25rem;font-size:1.02rem;}
  .author-box .bio{margin:0;font-size:0.88rem;color:#444;line-height:1.5;}

  /* Headings */
  h2{font-size:1.55rem;line-height:1.3;font-weight:800;margin:3rem 0 1rem;padding-top:1.5rem;border-top:1px solid var(--light-border);letter-spacing:-0.005em;scroll-margin-top:20px;}
  h3{font-size:1.18rem;font-weight:700;margin:2rem 0 0.6rem;color:var(--ink);}

  /* Paragraphs */
  p{margin:0 0 1.1rem;font-size:1.06rem;}
  a{color:var(--green);text-decoration:underline;text-underline-offset:3px;}

  /* TL;DR / Key Takeaways */
  blockquote{margin:2rem 0;padding:1.25rem 1.5rem;background:var(--cream);border-left:4px solid var(--green);border-radius:8px;}
  blockquote p{margin:0.4rem 0;font-size:1rem;}
  blockquote ul, blockquote ol {margin:0.5rem 0 0;padding-left:1.25rem;}
  blockquote li{margin-bottom:0.4rem;font-size:0.98rem;}

  /* TOC */
  nav.toc{background:var(--cream);padding:1.25rem 1.5rem;border-radius:8px;margin:0 0 2.5rem;border:1px solid var(--light-border);}
  nav.toc ol{margin:0;padding-left:1.4rem;}
  nav.toc li{margin-bottom:0.4rem;font-size:0.97rem;}
  nav.toc a{color:var(--ink);text-decoration:none;}
  nav.toc a:hover{color:var(--green);text-decoration:underline;}

  /* Lists */
  ul,ol{padding-left:1.4rem;}
  li{margin-bottom:0.5rem;}

  /* Tables */
  table{width:100%;border-collapse:collapse;margin:1.75rem 0;font-size:0.96rem;border-radius:8px;overflow:hidden;border:1px solid var(--light-border);}
  th,td{padding:11px 14px;border-bottom:1px solid var(--light-border);text-align:left;vertical-align:top;}
  th{background:var(--cream);font-weight:700;color:var(--ink);}
  tr:last-child td{border-bottom:none;}

  /* Figures + Charts */
  figure{margin:2.5rem 0;text-align:center;}
  figcaption{font-size:0.88rem;color:var(--mute);margin-top:0.5rem;}

  /* Quote Box (Prof. Amann-Jennson) */
  .quote-box{display:flex;gap:1.25rem;align-items:flex-start;background:var(--cream);border-radius:12px;padding:1.5rem 1.75rem;margin:2.5rem 0;border-left:4px solid var(--green);}
  .quote-box img{flex:0 0 80px;width:80px;height:80px;border-radius:50%;object-fit:cover;}
  .quote-box blockquote{margin:0;padding:0;background:transparent;border:none;}
  .quote-box blockquote p{margin:0 0 0.75rem;font-style:italic;font-size:1.06rem;color:var(--ink);line-height:1.5;}
  .quote-box blockquote footer{font-style:normal;font-size:0.9rem;color:var(--mute);}
  .quote-box blockquote footer strong{color:var(--ink);}

  /* CTA Boxes */
  a.cta-box{display:flex;align-items:center;gap:1.25rem;background:var(--cream);border-radius:12px;padding:1.25rem 1.5rem;margin:2rem 0;text-decoration:none;color:var(--ink);border:1px solid var(--light-border);transition:all 0.2s;}
  a.cta-box:hover{background:var(--cream-dark);transform:translateX(2px);}
  a.cta-box img{flex:0 0 88px;width:88px;height:88px;border-radius:8px;object-fit:cover;background:#fff;}
  a.cta-box > div{flex:1;}
  a.cta-box .cta-title{margin:0 0 0.35rem;font-weight:700;font-size:1.04rem;color:var(--ink);}
  a.cta-box .cta-desc{margin:0;font-size:0.92rem;color:#444;line-height:1.45;}
  a.cta-box .cta-arrow{font-size:1.5rem;color:var(--mute);flex:0 0 24px;}
  a.cta-box.cta-primary{background:var(--green);color:#fff;border-color:var(--green);}
  a.cta-box.cta-primary .cta-title{color:#fff;}
  a.cta-box.cta-primary .cta-desc{color:#dfe9e3;}
  a.cta-box.cta-primary .cta-arrow{color:#fff;}
  a.cta-box.cta-primary:hover{background:#234a32;}

  /* Webinar / Action banner */
  div[style*="border-left:4px solid #2d5a3d"]{box-shadow:0 1px 3px rgba(0,0,0,0.04);}

  /* Disclaimer */
  .disclaimer{background:var(--cream);border-left:4px solid #b08d4a;padding:1.25rem 1.5rem;margin:2.5rem 0;border-radius:6px;font-size:0.92rem;color:#444;}
  .disclaimer p{margin:0 0 0.75rem;font-size:0.92rem;}
  .disclaimer p:last-child{margin-bottom:0;}

  /* Sources */
  .sources{font-size:0.86rem;color:var(--mute);line-height:1.55;margin:2rem 0;padding:1rem 1.25rem;background:#fafaf7;border-radius:6px;}
  .sources strong{color:var(--ink);}

  /* Post navigation */
  .post-navigation{margin:3rem 0 1rem;padding:1.5rem 0;border-top:1px solid var(--light-border);border-bottom:1px solid var(--light-border);}
  .post-navigation .nav-heading{margin:0 0 0.75rem;font-size:0.88rem;color:var(--mute);text-transform:uppercase;letter-spacing:0.04em;}
  .post-navigation .nav-links{display:flex;justify-content:space-between;gap:1rem;flex-wrap:wrap;}
  .post-navigation a{color:var(--green);text-decoration:none;font-size:0.94rem;}
  .post-navigation a:hover{text-decoration:underline;}
  .post-navigation .next{text-align:right;}

  /* Tags */
  .post-tags{font-size:0.85rem;color:var(--mute);margin:1.5rem 0 0;}

  /* hr */
  hr{border:0;border-top:1px solid var(--light-border);margin:3rem 0;}

  /* Preview hint */
  .preview-hint{background:#fff4d6;border-left:4px solid #d4a300;padding:8px 14px;font-size:0.85rem;margin:0;color:#5a4500;text-align:center;}
</style>
</head>
<body>
<div class="preview-hint">📝 Lokale Vorschau · noch nicht publiziert · alle Links zeigen auf samina.com Platzhalter</div>
<div class="hero-wrap" style="position:relative;">
HTML_HEAD

# Extract hero figure from body and place it inside hero-wrap, rest goes into container
HERO=$(echo "$BODY" | awk '/<figure class="hero">/,/<\/figure>/' )
REST=$(echo "$BODY" | awk 'BEGIN{skip=0} /<figure class="hero">/{skip=1} skip==0{print} /<\/figure>/{if(skip==1){skip=0; next}}')

echo "$HERO" >> samina-longevity-blog.html
echo '</div><div class="container">' >> samina-longevity-blog.html
echo "$REST" >> samina-longevity-blog.html

cat >> samina-longevity-blog.html <<'HTML_FOOT'
</div>
</body>
</html>
HTML_FOOT

echo "OK - samina-longevity-blog.html geschrieben ($(wc -c < samina-longevity-blog.html) bytes)"
