!function(e,r){"function"==typeof define&&define.amd?define(r):"object"==typeof exports?module.exports=r(require,exports,module):e.gulpWrapUmd=r()}(this,function(){var e,r,n,t={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",decodeArrayBuffer:function(e){var r=e.length/4*3,n=new ArrayBuffer(r);return this.decode(e,n),n},decode:function(e,r){var n=this._keyStr.indexOf(e.charAt(e.length-1)),t=this._keyStr.indexOf(e.charAt(e.length-2)),i=e.length/4*3;64==n&&i--,64==t&&i--;var a,c,f,o,d,h,u,l,s=0,A=0;for(a=r?new Uint8Array(r):new Uint8Array(i),e=e.replace(/[^A-Za-z0-9\+\/=]/g,""),s=0;i>s;s+=3)d=this._keyStr.indexOf(e.charAt(A++)),h=this._keyStr.indexOf(e.charAt(A++)),u=this._keyStr.indexOf(e.charAt(A++)),l=this._keyStr.indexOf(e.charAt(A++)),c=d<<2|h>>4,f=(15&h)<<4|u>>2,o=(3&u)<<6|l,a[s]=c,64!=u&&(a[s+1]=f),64!=l&&(a[s+2]=o);return a}};return e=function(r){var n;return n=r.length,0===n?0:r[n-1]+(e(r.slice(0,n-1))<<8)},r=function(e){var r;return function(){var n,t,i;for(i=[],n=0,t=e.length;t>n;n++)r=e[n],i.push(String.fromCharCode(r));return i}().join("")},n=function(r){var n,i,a,c,f;return r=r.replace(/\r?\n/g,""),r=null!=(f=/AAAAB3NzaC1yc2E[A-Za-z0-9+\/=]+/.exec(r))?f[0]:void 0,null==r?"missing header":(n=t.decode(r),a=e(n.slice(11,15)),i=15+a,c=e(n.slice(i,+(i+3)+1||9e9)),i+=4+c,i!==n.length?"invalid key length":!0)}});