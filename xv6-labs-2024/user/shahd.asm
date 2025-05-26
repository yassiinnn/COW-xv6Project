
user/_shahd:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	e85a                	sd	s6,16(sp)
  12:	0880                	addi	s0,sp,80
  volatile int i;

  for(i = 1; i < argc; i++){
  14:	4785                	li	a5,1
  16:	faf42e23          	sw	a5,-68(s0)
  1a:	fbc42783          	lw	a5,-68(s0)
  1e:	06a7da63          	bge	a5,a0,92 <main+0x92>
  22:	84ae                	mv	s1,a1
  24:	892a                	mv	s2,a0
    write(1, argv[i], strlen(argv[i]));
  26:	4985                	li	s3,1
    if(i + 1 < argc){
      write(1, " ", 1);
    } else {
      write(1, "\n", 1);
  28:	00001a97          	auipc	s5,0x1
  2c:	8d0a8a93          	addi	s5,s5,-1840 # 8f8 <malloc+0x108>
      write(1, " ", 1);
  30:	00001a17          	auipc	s4,0x1
  34:	8c0a0a13          	addi	s4,s4,-1856 # 8f0 <malloc+0x100>
  38:	a005                	j	58 <main+0x58>
      write(1, "\n", 1);
  3a:	864e                	mv	a2,s3
  3c:	85d6                	mv	a1,s5
  3e:	854e                	mv	a0,s3
  40:	316000ef          	jal	356 <write>
  for(i = 1; i < argc; i++){
  44:	fbc42783          	lw	a5,-68(s0)
  48:	2785                	addiw	a5,a5,1
  4a:	faf42e23          	sw	a5,-68(s0)
  4e:	fbc42783          	lw	a5,-68(s0)
  52:	2781                	sext.w	a5,a5
  54:	0327df63          	bge	a5,s2,92 <main+0x92>
    write(1, argv[i], strlen(argv[i]));
  58:	fbc42783          	lw	a5,-68(s0)
  5c:	078e                	slli	a5,a5,0x3
  5e:	97a6                	add	a5,a5,s1
  60:	0007bb03          	ld	s6,0(a5)
  64:	fbc42783          	lw	a5,-68(s0)
  68:	078e                	slli	a5,a5,0x3
  6a:	97a6                	add	a5,a5,s1
  6c:	6388                	ld	a0,0(a5)
  6e:	08c000ef          	jal	fa <strlen>
  72:	862a                	mv	a2,a0
  74:	85da                	mv	a1,s6
  76:	854e                	mv	a0,s3
  78:	2de000ef          	jal	356 <write>
    if(i + 1 < argc){
  7c:	fbc42783          	lw	a5,-68(s0)
  80:	2785                	addiw	a5,a5,1
  82:	fb27dce3          	bge	a5,s2,3a <main+0x3a>
      write(1, " ", 1);
  86:	864e                	mv	a2,s3
  88:	85d2                	mv	a1,s4
  8a:	854e                	mv	a0,s3
  8c:	2ca000ef          	jal	356 <write>
  90:	bf55                	j	44 <main+0x44>
    }
  }
  exit(0);
  92:	4501                	li	a0,0
  94:	2a2000ef          	jal	336 <exit>

0000000000000098 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  98:	1141                	addi	sp,sp,-16
  9a:	e406                	sd	ra,8(sp)
  9c:	e022                	sd	s0,0(sp)
  9e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  a0:	f61ff0ef          	jal	0 <main>
  exit(0);
  a4:	4501                	li	a0,0
  a6:	290000ef          	jal	336 <exit>

00000000000000aa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e406                	sd	ra,8(sp)
  ae:	e022                	sd	s0,0(sp)
  b0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b2:	87aa                	mv	a5,a0
  b4:	0585                	addi	a1,a1,1
  b6:	0785                	addi	a5,a5,1
  b8:	fff5c703          	lbu	a4,-1(a1)
  bc:	fee78fa3          	sb	a4,-1(a5)
  c0:	fb75                	bnez	a4,b4 <strcpy+0xa>
    ;
  return os;
}
  c2:	60a2                	ld	ra,8(sp)
  c4:	6402                	ld	s0,0(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e406                	sd	ra,8(sp)
  ce:	e022                	sd	s0,0(sp)
  d0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cb91                	beqz	a5,ea <strcmp+0x20>
  d8:	0005c703          	lbu	a4,0(a1)
  dc:	00f71763          	bne	a4,a5,ea <strcmp+0x20>
    p++, q++;
  e0:	0505                	addi	a0,a0,1
  e2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	fbe5                	bnez	a5,d8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ea:	0005c503          	lbu	a0,0(a1)
}
  ee:	40a7853b          	subw	a0,a5,a0
  f2:	60a2                	ld	ra,8(sp)
  f4:	6402                	ld	s0,0(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strlen>:

uint
strlen(const char *s)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e406                	sd	ra,8(sp)
  fe:	e022                	sd	s0,0(sp)
 100:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 102:	00054783          	lbu	a5,0(a0)
 106:	cf99                	beqz	a5,124 <strlen+0x2a>
 108:	0505                	addi	a0,a0,1
 10a:	87aa                	mv	a5,a0
 10c:	86be                	mv	a3,a5
 10e:	0785                	addi	a5,a5,1
 110:	fff7c703          	lbu	a4,-1(a5)
 114:	ff65                	bnez	a4,10c <strlen+0x12>
 116:	40a6853b          	subw	a0,a3,a0
 11a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 11c:	60a2                	ld	ra,8(sp)
 11e:	6402                	ld	s0,0(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret
  for(n = 0; s[n]; n++)
 124:	4501                	li	a0,0
 126:	bfdd                	j	11c <strlen+0x22>

0000000000000128 <memset>:

void*
memset(void *dst, int c, uint n)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e406                	sd	ra,8(sp)
 12c:	e022                	sd	s0,0(sp)
 12e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 130:	ca19                	beqz	a2,146 <memset+0x1e>
 132:	87aa                	mv	a5,a0
 134:	1602                	slli	a2,a2,0x20
 136:	9201                	srli	a2,a2,0x20
 138:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 13c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 140:	0785                	addi	a5,a5,1
 142:	fee79de3          	bne	a5,a4,13c <memset+0x14>
  }
  return dst;
}
 146:	60a2                	ld	ra,8(sp)
 148:	6402                	ld	s0,0(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret

000000000000014e <strchr>:

char*
strchr(const char *s, char c)
{
 14e:	1141                	addi	sp,sp,-16
 150:	e406                	sd	ra,8(sp)
 152:	e022                	sd	s0,0(sp)
 154:	0800                	addi	s0,sp,16
  for(; *s; s++)
 156:	00054783          	lbu	a5,0(a0)
 15a:	cf81                	beqz	a5,172 <strchr+0x24>
    if(*s == c)
 15c:	00f58763          	beq	a1,a5,16a <strchr+0x1c>
  for(; *s; s++)
 160:	0505                	addi	a0,a0,1
 162:	00054783          	lbu	a5,0(a0)
 166:	fbfd                	bnez	a5,15c <strchr+0xe>
      return (char*)s;
  return 0;
 168:	4501                	li	a0,0
}
 16a:	60a2                	ld	ra,8(sp)
 16c:	6402                	ld	s0,0(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret
  return 0;
 172:	4501                	li	a0,0
 174:	bfdd                	j	16a <strchr+0x1c>

0000000000000176 <gets>:

char*
gets(char *buf, int max)
{
 176:	7159                	addi	sp,sp,-112
 178:	f486                	sd	ra,104(sp)
 17a:	f0a2                	sd	s0,96(sp)
 17c:	eca6                	sd	s1,88(sp)
 17e:	e8ca                	sd	s2,80(sp)
 180:	e4ce                	sd	s3,72(sp)
 182:	e0d2                	sd	s4,64(sp)
 184:	fc56                	sd	s5,56(sp)
 186:	f85a                	sd	s6,48(sp)
 188:	f45e                	sd	s7,40(sp)
 18a:	f062                	sd	s8,32(sp)
 18c:	ec66                	sd	s9,24(sp)
 18e:	e86a                	sd	s10,16(sp)
 190:	1880                	addi	s0,sp,112
 192:	8caa                	mv	s9,a0
 194:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 196:	892a                	mv	s2,a0
 198:	4481                	li	s1,0
    cc = read(0, &c, 1);
 19a:	f9f40b13          	addi	s6,s0,-97
 19e:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a0:	4ba9                	li	s7,10
 1a2:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1a4:	8d26                	mv	s10,s1
 1a6:	0014899b          	addiw	s3,s1,1
 1aa:	84ce                	mv	s1,s3
 1ac:	0349d563          	bge	s3,s4,1d6 <gets+0x60>
    cc = read(0, &c, 1);
 1b0:	8656                	mv	a2,s5
 1b2:	85da                	mv	a1,s6
 1b4:	4501                	li	a0,0
 1b6:	198000ef          	jal	34e <read>
    if(cc < 1)
 1ba:	00a05e63          	blez	a0,1d6 <gets+0x60>
    buf[i++] = c;
 1be:	f9f44783          	lbu	a5,-97(s0)
 1c2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1c6:	01778763          	beq	a5,s7,1d4 <gets+0x5e>
 1ca:	0905                	addi	s2,s2,1
 1cc:	fd879ce3          	bne	a5,s8,1a4 <gets+0x2e>
    buf[i++] = c;
 1d0:	8d4e                	mv	s10,s3
 1d2:	a011                	j	1d6 <gets+0x60>
 1d4:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1d6:	9d66                	add	s10,s10,s9
 1d8:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1dc:	8566                	mv	a0,s9
 1de:	70a6                	ld	ra,104(sp)
 1e0:	7406                	ld	s0,96(sp)
 1e2:	64e6                	ld	s1,88(sp)
 1e4:	6946                	ld	s2,80(sp)
 1e6:	69a6                	ld	s3,72(sp)
 1e8:	6a06                	ld	s4,64(sp)
 1ea:	7ae2                	ld	s5,56(sp)
 1ec:	7b42                	ld	s6,48(sp)
 1ee:	7ba2                	ld	s7,40(sp)
 1f0:	7c02                	ld	s8,32(sp)
 1f2:	6ce2                	ld	s9,24(sp)
 1f4:	6d42                	ld	s10,16(sp)
 1f6:	6165                	addi	sp,sp,112
 1f8:	8082                	ret

00000000000001fa <stat>:

int
stat(const char *n, struct stat *st)
{
 1fa:	1101                	addi	sp,sp,-32
 1fc:	ec06                	sd	ra,24(sp)
 1fe:	e822                	sd	s0,16(sp)
 200:	e04a                	sd	s2,0(sp)
 202:	1000                	addi	s0,sp,32
 204:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 206:	4581                	li	a1,0
 208:	16e000ef          	jal	376 <open>
  if(fd < 0)
 20c:	02054263          	bltz	a0,230 <stat+0x36>
 210:	e426                	sd	s1,8(sp)
 212:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 214:	85ca                	mv	a1,s2
 216:	178000ef          	jal	38e <fstat>
 21a:	892a                	mv	s2,a0
  close(fd);
 21c:	8526                	mv	a0,s1
 21e:	140000ef          	jal	35e <close>
  return r;
 222:	64a2                	ld	s1,8(sp)
}
 224:	854a                	mv	a0,s2
 226:	60e2                	ld	ra,24(sp)
 228:	6442                	ld	s0,16(sp)
 22a:	6902                	ld	s2,0(sp)
 22c:	6105                	addi	sp,sp,32
 22e:	8082                	ret
    return -1;
 230:	597d                	li	s2,-1
 232:	bfcd                	j	224 <stat+0x2a>

0000000000000234 <atoi>:

int
atoi(const char *s)
{
 234:	1141                	addi	sp,sp,-16
 236:	e406                	sd	ra,8(sp)
 238:	e022                	sd	s0,0(sp)
 23a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23c:	00054683          	lbu	a3,0(a0)
 240:	fd06879b          	addiw	a5,a3,-48
 244:	0ff7f793          	zext.b	a5,a5
 248:	4625                	li	a2,9
 24a:	02f66963          	bltu	a2,a5,27c <atoi+0x48>
 24e:	872a                	mv	a4,a0
  n = 0;
 250:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 252:	0705                	addi	a4,a4,1
 254:	0025179b          	slliw	a5,a0,0x2
 258:	9fa9                	addw	a5,a5,a0
 25a:	0017979b          	slliw	a5,a5,0x1
 25e:	9fb5                	addw	a5,a5,a3
 260:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 264:	00074683          	lbu	a3,0(a4)
 268:	fd06879b          	addiw	a5,a3,-48
 26c:	0ff7f793          	zext.b	a5,a5
 270:	fef671e3          	bgeu	a2,a5,252 <atoi+0x1e>
  return n;
}
 274:	60a2                	ld	ra,8(sp)
 276:	6402                	ld	s0,0(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
  n = 0;
 27c:	4501                	li	a0,0
 27e:	bfdd                	j	274 <atoi+0x40>

0000000000000280 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 288:	02b57563          	bgeu	a0,a1,2b2 <memmove+0x32>
    while(n-- > 0)
 28c:	00c05f63          	blez	a2,2aa <memmove+0x2a>
 290:	1602                	slli	a2,a2,0x20
 292:	9201                	srli	a2,a2,0x20
 294:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 298:	872a                	mv	a4,a0
      *dst++ = *src++;
 29a:	0585                	addi	a1,a1,1
 29c:	0705                	addi	a4,a4,1
 29e:	fff5c683          	lbu	a3,-1(a1)
 2a2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2a6:	fee79ae3          	bne	a5,a4,29a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2aa:	60a2                	ld	ra,8(sp)
 2ac:	6402                	ld	s0,0(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret
    dst += n;
 2b2:	00c50733          	add	a4,a0,a2
    src += n;
 2b6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2b8:	fec059e3          	blez	a2,2aa <memmove+0x2a>
 2bc:	fff6079b          	addiw	a5,a2,-1
 2c0:	1782                	slli	a5,a5,0x20
 2c2:	9381                	srli	a5,a5,0x20
 2c4:	fff7c793          	not	a5,a5
 2c8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ca:	15fd                	addi	a1,a1,-1
 2cc:	177d                	addi	a4,a4,-1
 2ce:	0005c683          	lbu	a3,0(a1)
 2d2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2d6:	fef71ae3          	bne	a4,a5,2ca <memmove+0x4a>
 2da:	bfc1                	j	2aa <memmove+0x2a>

00000000000002dc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2e4:	ca0d                	beqz	a2,316 <memcmp+0x3a>
 2e6:	fff6069b          	addiw	a3,a2,-1
 2ea:	1682                	slli	a3,a3,0x20
 2ec:	9281                	srli	a3,a3,0x20
 2ee:	0685                	addi	a3,a3,1
 2f0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2f2:	00054783          	lbu	a5,0(a0)
 2f6:	0005c703          	lbu	a4,0(a1)
 2fa:	00e79863          	bne	a5,a4,30a <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2fe:	0505                	addi	a0,a0,1
    p2++;
 300:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 302:	fed518e3          	bne	a0,a3,2f2 <memcmp+0x16>
  }
  return 0;
 306:	4501                	li	a0,0
 308:	a019                	j	30e <memcmp+0x32>
      return *p1 - *p2;
 30a:	40e7853b          	subw	a0,a5,a4
}
 30e:	60a2                	ld	ra,8(sp)
 310:	6402                	ld	s0,0(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret
  return 0;
 316:	4501                	li	a0,0
 318:	bfdd                	j	30e <memcmp+0x32>

000000000000031a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 31a:	1141                	addi	sp,sp,-16
 31c:	e406                	sd	ra,8(sp)
 31e:	e022                	sd	s0,0(sp)
 320:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 322:	f5fff0ef          	jal	280 <memmove>
}
 326:	60a2                	ld	ra,8(sp)
 328:	6402                	ld	s0,0(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret

000000000000032e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 32e:	4885                	li	a7,1
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <exit>:
.global exit
exit:
 li a7, SYS_exit
 336:	4889                	li	a7,2
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <wait>:
.global wait
wait:
 li a7, SYS_wait
 33e:	488d                	li	a7,3
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 346:	4891                	li	a7,4
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <read>:
.global read
read:
 li a7, SYS_read
 34e:	4895                	li	a7,5
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <write>:
.global write
write:
 li a7, SYS_write
 356:	48c1                	li	a7,16
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <close>:
.global close
close:
 li a7, SYS_close
 35e:	48d5                	li	a7,21
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <kill>:
.global kill
kill:
 li a7, SYS_kill
 366:	4899                	li	a7,6
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <exec>:
.global exec
exec:
 li a7, SYS_exec
 36e:	489d                	li	a7,7
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <open>:
.global open
open:
 li a7, SYS_open
 376:	48bd                	li	a7,15
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 37e:	48c5                	li	a7,17
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 386:	48c9                	li	a7,18
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 38e:	48a1                	li	a7,8
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <link>:
.global link
link:
 li a7, SYS_link
 396:	48cd                	li	a7,19
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 39e:	48d1                	li	a7,20
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a6:	48a5                	li	a7,9
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ae:	48a9                	li	a7,10
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b6:	48ad                	li	a7,11
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3be:	48b1                	li	a7,12
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3c6:	48b5                	li	a7,13
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ce:	48b9                	li	a7,14
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d6:	1101                	addi	sp,sp,-32
 3d8:	ec06                	sd	ra,24(sp)
 3da:	e822                	sd	s0,16(sp)
 3dc:	1000                	addi	s0,sp,32
 3de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3e2:	4605                	li	a2,1
 3e4:	fef40593          	addi	a1,s0,-17
 3e8:	f6fff0ef          	jal	356 <write>
}
 3ec:	60e2                	ld	ra,24(sp)
 3ee:	6442                	ld	s0,16(sp)
 3f0:	6105                	addi	sp,sp,32
 3f2:	8082                	ret

00000000000003f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f4:	7139                	addi	sp,sp,-64
 3f6:	fc06                	sd	ra,56(sp)
 3f8:	f822                	sd	s0,48(sp)
 3fa:	f426                	sd	s1,40(sp)
 3fc:	f04a                	sd	s2,32(sp)
 3fe:	ec4e                	sd	s3,24(sp)
 400:	0080                	addi	s0,sp,64
 402:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 404:	c299                	beqz	a3,40a <printint+0x16>
 406:	0605ce63          	bltz	a1,482 <printint+0x8e>
  neg = 0;
 40a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 40c:	fc040313          	addi	t1,s0,-64
  neg = 0;
 410:	869a                	mv	a3,t1
  i = 0;
 412:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 414:	00000817          	auipc	a6,0x0
 418:	4f480813          	addi	a6,a6,1268 # 908 <digits>
 41c:	88be                	mv	a7,a5
 41e:	0017851b          	addiw	a0,a5,1
 422:	87aa                	mv	a5,a0
 424:	02c5f73b          	remuw	a4,a1,a2
 428:	1702                	slli	a4,a4,0x20
 42a:	9301                	srli	a4,a4,0x20
 42c:	9742                	add	a4,a4,a6
 42e:	00074703          	lbu	a4,0(a4)
 432:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 436:	872e                	mv	a4,a1
 438:	02c5d5bb          	divuw	a1,a1,a2
 43c:	0685                	addi	a3,a3,1
 43e:	fcc77fe3          	bgeu	a4,a2,41c <printint+0x28>
  if(neg)
 442:	000e0c63          	beqz	t3,45a <printint+0x66>
    buf[i++] = '-';
 446:	fd050793          	addi	a5,a0,-48
 44a:	00878533          	add	a0,a5,s0
 44e:	02d00793          	li	a5,45
 452:	fef50823          	sb	a5,-16(a0)
 456:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 45a:	fff7899b          	addiw	s3,a5,-1
 45e:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 462:	fff4c583          	lbu	a1,-1(s1)
 466:	854a                	mv	a0,s2
 468:	f6fff0ef          	jal	3d6 <putc>
  while(--i >= 0)
 46c:	39fd                	addiw	s3,s3,-1
 46e:	14fd                	addi	s1,s1,-1
 470:	fe09d9e3          	bgez	s3,462 <printint+0x6e>
}
 474:	70e2                	ld	ra,56(sp)
 476:	7442                	ld	s0,48(sp)
 478:	74a2                	ld	s1,40(sp)
 47a:	7902                	ld	s2,32(sp)
 47c:	69e2                	ld	s3,24(sp)
 47e:	6121                	addi	sp,sp,64
 480:	8082                	ret
    x = -xx;
 482:	40b005bb          	negw	a1,a1
    neg = 1;
 486:	4e05                	li	t3,1
    x = -xx;
 488:	b751                	j	40c <printint+0x18>

000000000000048a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 48a:	711d                	addi	sp,sp,-96
 48c:	ec86                	sd	ra,88(sp)
 48e:	e8a2                	sd	s0,80(sp)
 490:	e4a6                	sd	s1,72(sp)
 492:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 494:	0005c483          	lbu	s1,0(a1)
 498:	26048663          	beqz	s1,704 <vprintf+0x27a>
 49c:	e0ca                	sd	s2,64(sp)
 49e:	fc4e                	sd	s3,56(sp)
 4a0:	f852                	sd	s4,48(sp)
 4a2:	f456                	sd	s5,40(sp)
 4a4:	f05a                	sd	s6,32(sp)
 4a6:	ec5e                	sd	s7,24(sp)
 4a8:	e862                	sd	s8,16(sp)
 4aa:	e466                	sd	s9,8(sp)
 4ac:	8b2a                	mv	s6,a0
 4ae:	8a2e                	mv	s4,a1
 4b0:	8bb2                	mv	s7,a2
  state = 0;
 4b2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4b4:	4901                	li	s2,0
 4b6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4b8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4bc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4c0:	06c00c93          	li	s9,108
 4c4:	a00d                	j	4e6 <vprintf+0x5c>
        putc(fd, c0);
 4c6:	85a6                	mv	a1,s1
 4c8:	855a                	mv	a0,s6
 4ca:	f0dff0ef          	jal	3d6 <putc>
 4ce:	a019                	j	4d4 <vprintf+0x4a>
    } else if(state == '%'){
 4d0:	03598363          	beq	s3,s5,4f6 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 4d4:	0019079b          	addiw	a5,s2,1
 4d8:	893e                	mv	s2,a5
 4da:	873e                	mv	a4,a5
 4dc:	97d2                	add	a5,a5,s4
 4de:	0007c483          	lbu	s1,0(a5)
 4e2:	20048963          	beqz	s1,6f4 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 4e6:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4ea:	fe0993e3          	bnez	s3,4d0 <vprintf+0x46>
      if(c0 == '%'){
 4ee:	fd579ce3          	bne	a5,s5,4c6 <vprintf+0x3c>
        state = '%';
 4f2:	89be                	mv	s3,a5
 4f4:	b7c5                	j	4d4 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4f6:	00ea06b3          	add	a3,s4,a4
 4fa:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4fe:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 500:	c681                	beqz	a3,508 <vprintf+0x7e>
 502:	9752                	add	a4,a4,s4
 504:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 508:	03878e63          	beq	a5,s8,544 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 50c:	05978863          	beq	a5,s9,55c <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 510:	07500713          	li	a4,117
 514:	0ee78263          	beq	a5,a4,5f8 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 518:	07800713          	li	a4,120
 51c:	12e78463          	beq	a5,a4,644 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 520:	07000713          	li	a4,112
 524:	14e78963          	beq	a5,a4,676 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 528:	07300713          	li	a4,115
 52c:	18e78863          	beq	a5,a4,6bc <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 530:	02500713          	li	a4,37
 534:	04e79463          	bne	a5,a4,57c <vprintf+0xf2>
        putc(fd, '%');
 538:	85ba                	mv	a1,a4
 53a:	855a                	mv	a0,s6
 53c:	e9bff0ef          	jal	3d6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 540:	4981                	li	s3,0
 542:	bf49                	j	4d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 544:	008b8493          	addi	s1,s7,8
 548:	4685                	li	a3,1
 54a:	4629                	li	a2,10
 54c:	000ba583          	lw	a1,0(s7)
 550:	855a                	mv	a0,s6
 552:	ea3ff0ef          	jal	3f4 <printint>
 556:	8ba6                	mv	s7,s1
      state = 0;
 558:	4981                	li	s3,0
 55a:	bfad                	j	4d4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 55c:	06400793          	li	a5,100
 560:	02f68963          	beq	a3,a5,592 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 564:	06c00793          	li	a5,108
 568:	04f68263          	beq	a3,a5,5ac <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 56c:	07500793          	li	a5,117
 570:	0af68063          	beq	a3,a5,610 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 574:	07800793          	li	a5,120
 578:	0ef68263          	beq	a3,a5,65c <vprintf+0x1d2>
        putc(fd, '%');
 57c:	02500593          	li	a1,37
 580:	855a                	mv	a0,s6
 582:	e55ff0ef          	jal	3d6 <putc>
        putc(fd, c0);
 586:	85a6                	mv	a1,s1
 588:	855a                	mv	a0,s6
 58a:	e4dff0ef          	jal	3d6 <putc>
      state = 0;
 58e:	4981                	li	s3,0
 590:	b791                	j	4d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 592:	008b8493          	addi	s1,s7,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000ba583          	lw	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	e55ff0ef          	jal	3f4 <printint>
        i += 1;
 5a4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a6:	8ba6                	mv	s7,s1
      state = 0;
 5a8:	4981                	li	s3,0
        i += 1;
 5aa:	b72d                	j	4d4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ac:	06400793          	li	a5,100
 5b0:	02f60763          	beq	a2,a5,5de <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5b4:	07500793          	li	a5,117
 5b8:	06f60963          	beq	a2,a5,62a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5bc:	07800793          	li	a5,120
 5c0:	faf61ee3          	bne	a2,a5,57c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c4:	008b8493          	addi	s1,s7,8
 5c8:	4681                	li	a3,0
 5ca:	4641                	li	a2,16
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	e23ff0ef          	jal	3f4 <printint>
        i += 2;
 5d6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d8:	8ba6                	mv	s7,s1
      state = 0;
 5da:	4981                	li	s3,0
        i += 2;
 5dc:	bde5                	j	4d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5de:	008b8493          	addi	s1,s7,8
 5e2:	4685                	li	a3,1
 5e4:	4629                	li	a2,10
 5e6:	000ba583          	lw	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	e09ff0ef          	jal	3f4 <printint>
        i += 2;
 5f0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f2:	8ba6                	mv	s7,s1
      state = 0;
 5f4:	4981                	li	s3,0
        i += 2;
 5f6:	bdf9                	j	4d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5f8:	008b8493          	addi	s1,s7,8
 5fc:	4681                	li	a3,0
 5fe:	4629                	li	a2,10
 600:	000ba583          	lw	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	defff0ef          	jal	3f4 <printint>
 60a:	8ba6                	mv	s7,s1
      state = 0;
 60c:	4981                	li	s3,0
 60e:	b5d9                	j	4d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 610:	008b8493          	addi	s1,s7,8
 614:	4681                	li	a3,0
 616:	4629                	li	a2,10
 618:	000ba583          	lw	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	dd7ff0ef          	jal	3f4 <printint>
        i += 1;
 622:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 624:	8ba6                	mv	s7,s1
      state = 0;
 626:	4981                	li	s3,0
        i += 1;
 628:	b575                	j	4d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62a:	008b8493          	addi	s1,s7,8
 62e:	4681                	li	a3,0
 630:	4629                	li	a2,10
 632:	000ba583          	lw	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	dbdff0ef          	jal	3f4 <printint>
        i += 2;
 63c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 63e:	8ba6                	mv	s7,s1
      state = 0;
 640:	4981                	li	s3,0
        i += 2;
 642:	bd49                	j	4d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 644:	008b8493          	addi	s1,s7,8
 648:	4681                	li	a3,0
 64a:	4641                	li	a2,16
 64c:	000ba583          	lw	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	da3ff0ef          	jal	3f4 <printint>
 656:	8ba6                	mv	s7,s1
      state = 0;
 658:	4981                	li	s3,0
 65a:	bdad                	j	4d4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65c:	008b8493          	addi	s1,s7,8
 660:	4681                	li	a3,0
 662:	4641                	li	a2,16
 664:	000ba583          	lw	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	d8bff0ef          	jal	3f4 <printint>
        i += 1;
 66e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 670:	8ba6                	mv	s7,s1
      state = 0;
 672:	4981                	li	s3,0
        i += 1;
 674:	b585                	j	4d4 <vprintf+0x4a>
 676:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 678:	008b8d13          	addi	s10,s7,8
 67c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 680:	03000593          	li	a1,48
 684:	855a                	mv	a0,s6
 686:	d51ff0ef          	jal	3d6 <putc>
  putc(fd, 'x');
 68a:	07800593          	li	a1,120
 68e:	855a                	mv	a0,s6
 690:	d47ff0ef          	jal	3d6 <putc>
 694:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 696:	00000b97          	auipc	s7,0x0
 69a:	272b8b93          	addi	s7,s7,626 # 908 <digits>
 69e:	03c9d793          	srli	a5,s3,0x3c
 6a2:	97de                	add	a5,a5,s7
 6a4:	0007c583          	lbu	a1,0(a5)
 6a8:	855a                	mv	a0,s6
 6aa:	d2dff0ef          	jal	3d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ae:	0992                	slli	s3,s3,0x4
 6b0:	34fd                	addiw	s1,s1,-1
 6b2:	f4f5                	bnez	s1,69e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6b4:	8bea                	mv	s7,s10
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	6d02                	ld	s10,0(sp)
 6ba:	bd29                	j	4d4 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6bc:	008b8993          	addi	s3,s7,8
 6c0:	000bb483          	ld	s1,0(s7)
 6c4:	cc91                	beqz	s1,6e0 <vprintf+0x256>
        for(; *s; s++)
 6c6:	0004c583          	lbu	a1,0(s1)
 6ca:	c195                	beqz	a1,6ee <vprintf+0x264>
          putc(fd, *s);
 6cc:	855a                	mv	a0,s6
 6ce:	d09ff0ef          	jal	3d6 <putc>
        for(; *s; s++)
 6d2:	0485                	addi	s1,s1,1
 6d4:	0004c583          	lbu	a1,0(s1)
 6d8:	f9f5                	bnez	a1,6cc <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6da:	8bce                	mv	s7,s3
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	bbdd                	j	4d4 <vprintf+0x4a>
          s = "(null)";
 6e0:	00000497          	auipc	s1,0x0
 6e4:	22048493          	addi	s1,s1,544 # 900 <malloc+0x110>
        for(; *s; s++)
 6e8:	02800593          	li	a1,40
 6ec:	b7c5                	j	6cc <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6ee:	8bce                	mv	s7,s3
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	b3cd                	j	4d4 <vprintf+0x4a>
 6f4:	6906                	ld	s2,64(sp)
 6f6:	79e2                	ld	s3,56(sp)
 6f8:	7a42                	ld	s4,48(sp)
 6fa:	7aa2                	ld	s5,40(sp)
 6fc:	7b02                	ld	s6,32(sp)
 6fe:	6be2                	ld	s7,24(sp)
 700:	6c42                	ld	s8,16(sp)
 702:	6ca2                	ld	s9,8(sp)
    }
  }
}
 704:	60e6                	ld	ra,88(sp)
 706:	6446                	ld	s0,80(sp)
 708:	64a6                	ld	s1,72(sp)
 70a:	6125                	addi	sp,sp,96
 70c:	8082                	ret

000000000000070e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 70e:	715d                	addi	sp,sp,-80
 710:	ec06                	sd	ra,24(sp)
 712:	e822                	sd	s0,16(sp)
 714:	1000                	addi	s0,sp,32
 716:	e010                	sd	a2,0(s0)
 718:	e414                	sd	a3,8(s0)
 71a:	e818                	sd	a4,16(s0)
 71c:	ec1c                	sd	a5,24(s0)
 71e:	03043023          	sd	a6,32(s0)
 722:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 726:	8622                	mv	a2,s0
 728:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 72c:	d5fff0ef          	jal	48a <vprintf>
}
 730:	60e2                	ld	ra,24(sp)
 732:	6442                	ld	s0,16(sp)
 734:	6161                	addi	sp,sp,80
 736:	8082                	ret

0000000000000738 <printf>:

void
printf(const char *fmt, ...)
{
 738:	711d                	addi	sp,sp,-96
 73a:	ec06                	sd	ra,24(sp)
 73c:	e822                	sd	s0,16(sp)
 73e:	1000                	addi	s0,sp,32
 740:	e40c                	sd	a1,8(s0)
 742:	e810                	sd	a2,16(s0)
 744:	ec14                	sd	a3,24(s0)
 746:	f018                	sd	a4,32(s0)
 748:	f41c                	sd	a5,40(s0)
 74a:	03043823          	sd	a6,48(s0)
 74e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 752:	00840613          	addi	a2,s0,8
 756:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 75a:	85aa                	mv	a1,a0
 75c:	4505                	li	a0,1
 75e:	d2dff0ef          	jal	48a <vprintf>
}
 762:	60e2                	ld	ra,24(sp)
 764:	6442                	ld	s0,16(sp)
 766:	6125                	addi	sp,sp,96
 768:	8082                	ret

000000000000076a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76a:	1141                	addi	sp,sp,-16
 76c:	e406                	sd	ra,8(sp)
 76e:	e022                	sd	s0,0(sp)
 770:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 772:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 776:	00001797          	auipc	a5,0x1
 77a:	88a7b783          	ld	a5,-1910(a5) # 1000 <freep>
 77e:	a02d                	j	7a8 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 780:	4618                	lw	a4,8(a2)
 782:	9f2d                	addw	a4,a4,a1
 784:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 788:	6398                	ld	a4,0(a5)
 78a:	6310                	ld	a2,0(a4)
 78c:	a83d                	j	7ca <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 78e:	ff852703          	lw	a4,-8(a0)
 792:	9f31                	addw	a4,a4,a2
 794:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 796:	ff053683          	ld	a3,-16(a0)
 79a:	a091                	j	7de <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79c:	6398                	ld	a4,0(a5)
 79e:	00e7e463          	bltu	a5,a4,7a6 <free+0x3c>
 7a2:	00e6ea63          	bltu	a3,a4,7b6 <free+0x4c>
{
 7a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a8:	fed7fae3          	bgeu	a5,a3,79c <free+0x32>
 7ac:	6398                	ld	a4,0(a5)
 7ae:	00e6e463          	bltu	a3,a4,7b6 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b2:	fee7eae3          	bltu	a5,a4,7a6 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 7b6:	ff852583          	lw	a1,-8(a0)
 7ba:	6390                	ld	a2,0(a5)
 7bc:	02059813          	slli	a6,a1,0x20
 7c0:	01c85713          	srli	a4,a6,0x1c
 7c4:	9736                	add	a4,a4,a3
 7c6:	fae60de3          	beq	a2,a4,780 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7ca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ce:	4790                	lw	a2,8(a5)
 7d0:	02061593          	slli	a1,a2,0x20
 7d4:	01c5d713          	srli	a4,a1,0x1c
 7d8:	973e                	add	a4,a4,a5
 7da:	fae68ae3          	beq	a3,a4,78e <free+0x24>
    p->s.ptr = bp->s.ptr;
 7de:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7e0:	00001717          	auipc	a4,0x1
 7e4:	82f73023          	sd	a5,-2016(a4) # 1000 <freep>
}
 7e8:	60a2                	ld	ra,8(sp)
 7ea:	6402                	ld	s0,0(sp)
 7ec:	0141                	addi	sp,sp,16
 7ee:	8082                	ret

00000000000007f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f0:	7139                	addi	sp,sp,-64
 7f2:	fc06                	sd	ra,56(sp)
 7f4:	f822                	sd	s0,48(sp)
 7f6:	f04a                	sd	s2,32(sp)
 7f8:	ec4e                	sd	s3,24(sp)
 7fa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fc:	02051993          	slli	s3,a0,0x20
 800:	0209d993          	srli	s3,s3,0x20
 804:	09bd                	addi	s3,s3,15
 806:	0049d993          	srli	s3,s3,0x4
 80a:	2985                	addiw	s3,s3,1
 80c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 80e:	00000517          	auipc	a0,0x0
 812:	7f253503          	ld	a0,2034(a0) # 1000 <freep>
 816:	c905                	beqz	a0,846 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 818:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81a:	4798                	lw	a4,8(a5)
 81c:	09377663          	bgeu	a4,s3,8a8 <malloc+0xb8>
 820:	f426                	sd	s1,40(sp)
 822:	e852                	sd	s4,16(sp)
 824:	e456                	sd	s5,8(sp)
 826:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 828:	8a4e                	mv	s4,s3
 82a:	6705                	lui	a4,0x1
 82c:	00e9f363          	bgeu	s3,a4,832 <malloc+0x42>
 830:	6a05                	lui	s4,0x1
 832:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 836:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 83a:	00000497          	auipc	s1,0x0
 83e:	7c648493          	addi	s1,s1,1990 # 1000 <freep>
  if(p == (char*)-1)
 842:	5afd                	li	s5,-1
 844:	a83d                	j	882 <malloc+0x92>
 846:	f426                	sd	s1,40(sp)
 848:	e852                	sd	s4,16(sp)
 84a:	e456                	sd	s5,8(sp)
 84c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 84e:	00000797          	auipc	a5,0x0
 852:	7c278793          	addi	a5,a5,1986 # 1010 <base>
 856:	00000717          	auipc	a4,0x0
 85a:	7af73523          	sd	a5,1962(a4) # 1000 <freep>
 85e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 860:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 864:	b7d1                	j	828 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 866:	6398                	ld	a4,0(a5)
 868:	e118                	sd	a4,0(a0)
 86a:	a899                	j	8c0 <malloc+0xd0>
  hp->s.size = nu;
 86c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 870:	0541                	addi	a0,a0,16
 872:	ef9ff0ef          	jal	76a <free>
  return freep;
 876:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 878:	c125                	beqz	a0,8d8 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87c:	4798                	lw	a4,8(a5)
 87e:	03277163          	bgeu	a4,s2,8a0 <malloc+0xb0>
    if(p == freep)
 882:	6098                	ld	a4,0(s1)
 884:	853e                	mv	a0,a5
 886:	fef71ae3          	bne	a4,a5,87a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 88a:	8552                	mv	a0,s4
 88c:	b33ff0ef          	jal	3be <sbrk>
  if(p == (char*)-1)
 890:	fd551ee3          	bne	a0,s5,86c <malloc+0x7c>
        return 0;
 894:	4501                	li	a0,0
 896:	74a2                	ld	s1,40(sp)
 898:	6a42                	ld	s4,16(sp)
 89a:	6aa2                	ld	s5,8(sp)
 89c:	6b02                	ld	s6,0(sp)
 89e:	a03d                	j	8cc <malloc+0xdc>
 8a0:	74a2                	ld	s1,40(sp)
 8a2:	6a42                	ld	s4,16(sp)
 8a4:	6aa2                	ld	s5,8(sp)
 8a6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8a8:	fae90fe3          	beq	s2,a4,866 <malloc+0x76>
        p->s.size -= nunits;
 8ac:	4137073b          	subw	a4,a4,s3
 8b0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8b2:	02071693          	slli	a3,a4,0x20
 8b6:	01c6d713          	srli	a4,a3,0x1c
 8ba:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8bc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c0:	00000717          	auipc	a4,0x0
 8c4:	74a73023          	sd	a0,1856(a4) # 1000 <freep>
      return (void*)(p + 1);
 8c8:	01078513          	addi	a0,a5,16
  }
}
 8cc:	70e2                	ld	ra,56(sp)
 8ce:	7442                	ld	s0,48(sp)
 8d0:	7902                	ld	s2,32(sp)
 8d2:	69e2                	ld	s3,24(sp)
 8d4:	6121                	addi	sp,sp,64
 8d6:	8082                	ret
 8d8:	74a2                	ld	s1,40(sp)
 8da:	6a42                	ld	s4,16(sp)
 8dc:	6aa2                	ld	s5,8(sp)
 8de:	6b02                	ld	s6,0(sp)
 8e0:	b7f5                	j	8cc <malloc+0xdc>
