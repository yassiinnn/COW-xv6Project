
user/_shahdMansour:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
//communication between two processes
#include "kernel/types.h"
#include "user/user.h"

int main () {
   0:	7135                	addi	sp,sp,-160
   2:	ed06                	sd	ra,152(sp)
   4:	e922                	sd	s0,144(sp)
   6:	e526                	sd	s1,136(sp)
   8:	1100                	addi	s0,sp,160
  int n, pid;
  int fds[2];
  int fds2[2];
  char buf[100];
  
  pipe(fds);
   a:	fd840513          	addi	a0,s0,-40
   e:	32e000ef          	jal	33c <pipe>
  pipe(fds2);
  12:	fd040513          	addi	a0,s0,-48
  16:	326000ef          	jal	33c <pipe>
  pid = fork();
  1a:	30a000ef          	jal	324 <fork>
  
  if (pid == 0) {
  1e:	ed05                	bnez	a0,56 <main+0x56>
    write(fds[1], "i am a child, and i will send this string to parent.\n", 52);
  20:	03400613          	li	a2,52
  24:	00001597          	auipc	a1,0x1
  28:	8bc58593          	addi	a1,a1,-1860 # 8e0 <malloc+0xfa>
  2c:	fdc42503          	lw	a0,-36(s0)
  30:	31c000ef          	jal	34c <write>
    
    n = read(fds2[0], buf, sizeof(buf));
  34:	f6840493          	addi	s1,s0,-152
  38:	06400613          	li	a2,100
  3c:	85a6                	mv	a1,s1
  3e:	fd042503          	lw	a0,-48(s0)
  42:	302000ef          	jal	344 <read>
  46:	862a                	mv	a2,a0
    write(1, buf, n);
  48:	85a6                	mv	a1,s1
  4a:	4505                	li	a0,1
  4c:	300000ef          	jal	34c <write>

    write(fds2[1], "i am a parent, and i received this string from child.\n", 55);
    wait(0);
  }
  
  exit(0);
  50:	4501                	li	a0,0
  52:	2da000ef          	jal	32c <exit>
    n = read(fds[0], buf, sizeof(buf));
  56:	f6840493          	addi	s1,s0,-152
  5a:	06400613          	li	a2,100
  5e:	85a6                	mv	a1,s1
  60:	fd842503          	lw	a0,-40(s0)
  64:	2e0000ef          	jal	344 <read>
  68:	862a                	mv	a2,a0
    write(1, buf, n);
  6a:	85a6                	mv	a1,s1
  6c:	4505                	li	a0,1
  6e:	2de000ef          	jal	34c <write>
    write(fds2[1], "i am a parent, and i received this string from child.\n", 55);
  72:	03700613          	li	a2,55
  76:	00001597          	auipc	a1,0x1
  7a:	8a258593          	addi	a1,a1,-1886 # 918 <malloc+0x132>
  7e:	fd442503          	lw	a0,-44(s0)
  82:	2ca000ef          	jal	34c <write>
    wait(0);
  86:	4501                	li	a0,0
  88:	2ac000ef          	jal	334 <wait>
  8c:	b7d1                	j	50 <main+0x50>

000000000000008e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  8e:	1141                	addi	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	addi	s0,sp,16
  extern int main();
  main();
  96:	f6bff0ef          	jal	0 <main>
  exit(0);
  9a:	4501                	li	a0,0
  9c:	290000ef          	jal	32c <exit>

00000000000000a0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e406                	sd	ra,8(sp)
  a4:	e022                	sd	s0,0(sp)
  a6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a8:	87aa                	mv	a5,a0
  aa:	0585                	addi	a1,a1,1
  ac:	0785                	addi	a5,a5,1
  ae:	fff5c703          	lbu	a4,-1(a1)
  b2:	fee78fa3          	sb	a4,-1(a5)
  b6:	fb75                	bnez	a4,aa <strcpy+0xa>
    ;
  return os;
}
  b8:	60a2                	ld	ra,8(sp)
  ba:	6402                	ld	s0,0(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e406                	sd	ra,8(sp)
  c4:	e022                	sd	s0,0(sp)
  c6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	cb91                	beqz	a5,e0 <strcmp+0x20>
  ce:	0005c703          	lbu	a4,0(a1)
  d2:	00f71763          	bne	a4,a5,e0 <strcmp+0x20>
    p++, q++;
  d6:	0505                	addi	a0,a0,1
  d8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  da:	00054783          	lbu	a5,0(a0)
  de:	fbe5                	bnez	a5,ce <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  e0:	0005c503          	lbu	a0,0(a1)
}
  e4:	40a7853b          	subw	a0,a5,a0
  e8:	60a2                	ld	ra,8(sp)
  ea:	6402                	ld	s0,0(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret

00000000000000f0 <strlen>:

uint
strlen(const char *s)
{
  f0:	1141                	addi	sp,sp,-16
  f2:	e406                	sd	ra,8(sp)
  f4:	e022                	sd	s0,0(sp)
  f6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  f8:	00054783          	lbu	a5,0(a0)
  fc:	cf99                	beqz	a5,11a <strlen+0x2a>
  fe:	0505                	addi	a0,a0,1
 100:	87aa                	mv	a5,a0
 102:	86be                	mv	a3,a5
 104:	0785                	addi	a5,a5,1
 106:	fff7c703          	lbu	a4,-1(a5)
 10a:	ff65                	bnez	a4,102 <strlen+0x12>
 10c:	40a6853b          	subw	a0,a3,a0
 110:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 112:	60a2                	ld	ra,8(sp)
 114:	6402                	ld	s0,0(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret
  for(n = 0; s[n]; n++)
 11a:	4501                	li	a0,0
 11c:	bfdd                	j	112 <strlen+0x22>

000000000000011e <memset>:

void*
memset(void *dst, int c, uint n)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 126:	ca19                	beqz	a2,13c <memset+0x1e>
 128:	87aa                	mv	a5,a0
 12a:	1602                	slli	a2,a2,0x20
 12c:	9201                	srli	a2,a2,0x20
 12e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 132:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 136:	0785                	addi	a5,a5,1
 138:	fee79de3          	bne	a5,a4,132 <memset+0x14>
  }
  return dst;
}
 13c:	60a2                	ld	ra,8(sp)
 13e:	6402                	ld	s0,0(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret

0000000000000144 <strchr>:

char*
strchr(const char *s, char c)
{
 144:	1141                	addi	sp,sp,-16
 146:	e406                	sd	ra,8(sp)
 148:	e022                	sd	s0,0(sp)
 14a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 14c:	00054783          	lbu	a5,0(a0)
 150:	cf81                	beqz	a5,168 <strchr+0x24>
    if(*s == c)
 152:	00f58763          	beq	a1,a5,160 <strchr+0x1c>
  for(; *s; s++)
 156:	0505                	addi	a0,a0,1
 158:	00054783          	lbu	a5,0(a0)
 15c:	fbfd                	bnez	a5,152 <strchr+0xe>
      return (char*)s;
  return 0;
 15e:	4501                	li	a0,0
}
 160:	60a2                	ld	ra,8(sp)
 162:	6402                	ld	s0,0(sp)
 164:	0141                	addi	sp,sp,16
 166:	8082                	ret
  return 0;
 168:	4501                	li	a0,0
 16a:	bfdd                	j	160 <strchr+0x1c>

000000000000016c <gets>:

char*
gets(char *buf, int max)
{
 16c:	7159                	addi	sp,sp,-112
 16e:	f486                	sd	ra,104(sp)
 170:	f0a2                	sd	s0,96(sp)
 172:	eca6                	sd	s1,88(sp)
 174:	e8ca                	sd	s2,80(sp)
 176:	e4ce                	sd	s3,72(sp)
 178:	e0d2                	sd	s4,64(sp)
 17a:	fc56                	sd	s5,56(sp)
 17c:	f85a                	sd	s6,48(sp)
 17e:	f45e                	sd	s7,40(sp)
 180:	f062                	sd	s8,32(sp)
 182:	ec66                	sd	s9,24(sp)
 184:	e86a                	sd	s10,16(sp)
 186:	1880                	addi	s0,sp,112
 188:	8caa                	mv	s9,a0
 18a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18c:	892a                	mv	s2,a0
 18e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 190:	f9f40b13          	addi	s6,s0,-97
 194:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 196:	4ba9                	li	s7,10
 198:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 19a:	8d26                	mv	s10,s1
 19c:	0014899b          	addiw	s3,s1,1
 1a0:	84ce                	mv	s1,s3
 1a2:	0349d563          	bge	s3,s4,1cc <gets+0x60>
    cc = read(0, &c, 1);
 1a6:	8656                	mv	a2,s5
 1a8:	85da                	mv	a1,s6
 1aa:	4501                	li	a0,0
 1ac:	198000ef          	jal	344 <read>
    if(cc < 1)
 1b0:	00a05e63          	blez	a0,1cc <gets+0x60>
    buf[i++] = c;
 1b4:	f9f44783          	lbu	a5,-97(s0)
 1b8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1bc:	01778763          	beq	a5,s7,1ca <gets+0x5e>
 1c0:	0905                	addi	s2,s2,1
 1c2:	fd879ce3          	bne	a5,s8,19a <gets+0x2e>
    buf[i++] = c;
 1c6:	8d4e                	mv	s10,s3
 1c8:	a011                	j	1cc <gets+0x60>
 1ca:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1cc:	9d66                	add	s10,s10,s9
 1ce:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1d2:	8566                	mv	a0,s9
 1d4:	70a6                	ld	ra,104(sp)
 1d6:	7406                	ld	s0,96(sp)
 1d8:	64e6                	ld	s1,88(sp)
 1da:	6946                	ld	s2,80(sp)
 1dc:	69a6                	ld	s3,72(sp)
 1de:	6a06                	ld	s4,64(sp)
 1e0:	7ae2                	ld	s5,56(sp)
 1e2:	7b42                	ld	s6,48(sp)
 1e4:	7ba2                	ld	s7,40(sp)
 1e6:	7c02                	ld	s8,32(sp)
 1e8:	6ce2                	ld	s9,24(sp)
 1ea:	6d42                	ld	s10,16(sp)
 1ec:	6165                	addi	sp,sp,112
 1ee:	8082                	ret

00000000000001f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f0:	1101                	addi	sp,sp,-32
 1f2:	ec06                	sd	ra,24(sp)
 1f4:	e822                	sd	s0,16(sp)
 1f6:	e04a                	sd	s2,0(sp)
 1f8:	1000                	addi	s0,sp,32
 1fa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fc:	4581                	li	a1,0
 1fe:	16e000ef          	jal	36c <open>
  if(fd < 0)
 202:	02054263          	bltz	a0,226 <stat+0x36>
 206:	e426                	sd	s1,8(sp)
 208:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 20a:	85ca                	mv	a1,s2
 20c:	178000ef          	jal	384 <fstat>
 210:	892a                	mv	s2,a0
  close(fd);
 212:	8526                	mv	a0,s1
 214:	140000ef          	jal	354 <close>
  return r;
 218:	64a2                	ld	s1,8(sp)
}
 21a:	854a                	mv	a0,s2
 21c:	60e2                	ld	ra,24(sp)
 21e:	6442                	ld	s0,16(sp)
 220:	6902                	ld	s2,0(sp)
 222:	6105                	addi	sp,sp,32
 224:	8082                	ret
    return -1;
 226:	597d                	li	s2,-1
 228:	bfcd                	j	21a <stat+0x2a>

000000000000022a <atoi>:

int
atoi(const char *s)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e406                	sd	ra,8(sp)
 22e:	e022                	sd	s0,0(sp)
 230:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 232:	00054683          	lbu	a3,0(a0)
 236:	fd06879b          	addiw	a5,a3,-48
 23a:	0ff7f793          	zext.b	a5,a5
 23e:	4625                	li	a2,9
 240:	02f66963          	bltu	a2,a5,272 <atoi+0x48>
 244:	872a                	mv	a4,a0
  n = 0;
 246:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 248:	0705                	addi	a4,a4,1
 24a:	0025179b          	slliw	a5,a0,0x2
 24e:	9fa9                	addw	a5,a5,a0
 250:	0017979b          	slliw	a5,a5,0x1
 254:	9fb5                	addw	a5,a5,a3
 256:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 25a:	00074683          	lbu	a3,0(a4)
 25e:	fd06879b          	addiw	a5,a3,-48
 262:	0ff7f793          	zext.b	a5,a5
 266:	fef671e3          	bgeu	a2,a5,248 <atoi+0x1e>
  return n;
}
 26a:	60a2                	ld	ra,8(sp)
 26c:	6402                	ld	s0,0(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
  n = 0;
 272:	4501                	li	a0,0
 274:	bfdd                	j	26a <atoi+0x40>

0000000000000276 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 276:	1141                	addi	sp,sp,-16
 278:	e406                	sd	ra,8(sp)
 27a:	e022                	sd	s0,0(sp)
 27c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 27e:	02b57563          	bgeu	a0,a1,2a8 <memmove+0x32>
    while(n-- > 0)
 282:	00c05f63          	blez	a2,2a0 <memmove+0x2a>
 286:	1602                	slli	a2,a2,0x20
 288:	9201                	srli	a2,a2,0x20
 28a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 28e:	872a                	mv	a4,a0
      *dst++ = *src++;
 290:	0585                	addi	a1,a1,1
 292:	0705                	addi	a4,a4,1
 294:	fff5c683          	lbu	a3,-1(a1)
 298:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 29c:	fee79ae3          	bne	a5,a4,290 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2a0:	60a2                	ld	ra,8(sp)
 2a2:	6402                	ld	s0,0(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret
    dst += n;
 2a8:	00c50733          	add	a4,a0,a2
    src += n;
 2ac:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ae:	fec059e3          	blez	a2,2a0 <memmove+0x2a>
 2b2:	fff6079b          	addiw	a5,a2,-1
 2b6:	1782                	slli	a5,a5,0x20
 2b8:	9381                	srli	a5,a5,0x20
 2ba:	fff7c793          	not	a5,a5
 2be:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2c0:	15fd                	addi	a1,a1,-1
 2c2:	177d                	addi	a4,a4,-1
 2c4:	0005c683          	lbu	a3,0(a1)
 2c8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2cc:	fef71ae3          	bne	a4,a5,2c0 <memmove+0x4a>
 2d0:	bfc1                	j	2a0 <memmove+0x2a>

00000000000002d2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2da:	ca0d                	beqz	a2,30c <memcmp+0x3a>
 2dc:	fff6069b          	addiw	a3,a2,-1
 2e0:	1682                	slli	a3,a3,0x20
 2e2:	9281                	srli	a3,a3,0x20
 2e4:	0685                	addi	a3,a3,1
 2e6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2e8:	00054783          	lbu	a5,0(a0)
 2ec:	0005c703          	lbu	a4,0(a1)
 2f0:	00e79863          	bne	a5,a4,300 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2f4:	0505                	addi	a0,a0,1
    p2++;
 2f6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2f8:	fed518e3          	bne	a0,a3,2e8 <memcmp+0x16>
  }
  return 0;
 2fc:	4501                	li	a0,0
 2fe:	a019                	j	304 <memcmp+0x32>
      return *p1 - *p2;
 300:	40e7853b          	subw	a0,a5,a4
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret
  return 0;
 30c:	4501                	li	a0,0
 30e:	bfdd                	j	304 <memcmp+0x32>

0000000000000310 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 310:	1141                	addi	sp,sp,-16
 312:	e406                	sd	ra,8(sp)
 314:	e022                	sd	s0,0(sp)
 316:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 318:	f5fff0ef          	jal	276 <memmove>
}
 31c:	60a2                	ld	ra,8(sp)
 31e:	6402                	ld	s0,0(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret

0000000000000324 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 324:	4885                	li	a7,1
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <exit>:
.global exit
exit:
 li a7, SYS_exit
 32c:	4889                	li	a7,2
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <wait>:
.global wait
wait:
 li a7, SYS_wait
 334:	488d                	li	a7,3
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 33c:	4891                	li	a7,4
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <read>:
.global read
read:
 li a7, SYS_read
 344:	4895                	li	a7,5
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <write>:
.global write
write:
 li a7, SYS_write
 34c:	48c1                	li	a7,16
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <close>:
.global close
close:
 li a7, SYS_close
 354:	48d5                	li	a7,21
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <kill>:
.global kill
kill:
 li a7, SYS_kill
 35c:	4899                	li	a7,6
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <exec>:
.global exec
exec:
 li a7, SYS_exec
 364:	489d                	li	a7,7
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <open>:
.global open
open:
 li a7, SYS_open
 36c:	48bd                	li	a7,15
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 374:	48c5                	li	a7,17
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 37c:	48c9                	li	a7,18
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 384:	48a1                	li	a7,8
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <link>:
.global link
link:
 li a7, SYS_link
 38c:	48cd                	li	a7,19
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 394:	48d1                	li	a7,20
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 39c:	48a5                	li	a7,9
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3a4:	48a9                	li	a7,10
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ac:	48ad                	li	a7,11
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3b4:	48b1                	li	a7,12
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3bc:	48b5                	li	a7,13
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3c4:	48b9                	li	a7,14
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3cc:	1101                	addi	sp,sp,-32
 3ce:	ec06                	sd	ra,24(sp)
 3d0:	e822                	sd	s0,16(sp)
 3d2:	1000                	addi	s0,sp,32
 3d4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d8:	4605                	li	a2,1
 3da:	fef40593          	addi	a1,s0,-17
 3de:	f6fff0ef          	jal	34c <write>
}
 3e2:	60e2                	ld	ra,24(sp)
 3e4:	6442                	ld	s0,16(sp)
 3e6:	6105                	addi	sp,sp,32
 3e8:	8082                	ret

00000000000003ea <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ea:	7139                	addi	sp,sp,-64
 3ec:	fc06                	sd	ra,56(sp)
 3ee:	f822                	sd	s0,48(sp)
 3f0:	f426                	sd	s1,40(sp)
 3f2:	f04a                	sd	s2,32(sp)
 3f4:	ec4e                	sd	s3,24(sp)
 3f6:	0080                	addi	s0,sp,64
 3f8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fa:	c299                	beqz	a3,400 <printint+0x16>
 3fc:	0605ce63          	bltz	a1,478 <printint+0x8e>
  neg = 0;
 400:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 402:	fc040313          	addi	t1,s0,-64
  neg = 0;
 406:	869a                	mv	a3,t1
  i = 0;
 408:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 40a:	00000817          	auipc	a6,0x0
 40e:	54e80813          	addi	a6,a6,1358 # 958 <digits>
 412:	88be                	mv	a7,a5
 414:	0017851b          	addiw	a0,a5,1
 418:	87aa                	mv	a5,a0
 41a:	02c5f73b          	remuw	a4,a1,a2
 41e:	1702                	slli	a4,a4,0x20
 420:	9301                	srli	a4,a4,0x20
 422:	9742                	add	a4,a4,a6
 424:	00074703          	lbu	a4,0(a4)
 428:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 42c:	872e                	mv	a4,a1
 42e:	02c5d5bb          	divuw	a1,a1,a2
 432:	0685                	addi	a3,a3,1
 434:	fcc77fe3          	bgeu	a4,a2,412 <printint+0x28>
  if(neg)
 438:	000e0c63          	beqz	t3,450 <printint+0x66>
    buf[i++] = '-';
 43c:	fd050793          	addi	a5,a0,-48
 440:	00878533          	add	a0,a5,s0
 444:	02d00793          	li	a5,45
 448:	fef50823          	sb	a5,-16(a0)
 44c:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 450:	fff7899b          	addiw	s3,a5,-1
 454:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 458:	fff4c583          	lbu	a1,-1(s1)
 45c:	854a                	mv	a0,s2
 45e:	f6fff0ef          	jal	3cc <putc>
  while(--i >= 0)
 462:	39fd                	addiw	s3,s3,-1
 464:	14fd                	addi	s1,s1,-1
 466:	fe09d9e3          	bgez	s3,458 <printint+0x6e>
}
 46a:	70e2                	ld	ra,56(sp)
 46c:	7442                	ld	s0,48(sp)
 46e:	74a2                	ld	s1,40(sp)
 470:	7902                	ld	s2,32(sp)
 472:	69e2                	ld	s3,24(sp)
 474:	6121                	addi	sp,sp,64
 476:	8082                	ret
    x = -xx;
 478:	40b005bb          	negw	a1,a1
    neg = 1;
 47c:	4e05                	li	t3,1
    x = -xx;
 47e:	b751                	j	402 <printint+0x18>

0000000000000480 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 480:	711d                	addi	sp,sp,-96
 482:	ec86                	sd	ra,88(sp)
 484:	e8a2                	sd	s0,80(sp)
 486:	e4a6                	sd	s1,72(sp)
 488:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 48a:	0005c483          	lbu	s1,0(a1)
 48e:	26048663          	beqz	s1,6fa <vprintf+0x27a>
 492:	e0ca                	sd	s2,64(sp)
 494:	fc4e                	sd	s3,56(sp)
 496:	f852                	sd	s4,48(sp)
 498:	f456                	sd	s5,40(sp)
 49a:	f05a                	sd	s6,32(sp)
 49c:	ec5e                	sd	s7,24(sp)
 49e:	e862                	sd	s8,16(sp)
 4a0:	e466                	sd	s9,8(sp)
 4a2:	8b2a                	mv	s6,a0
 4a4:	8a2e                	mv	s4,a1
 4a6:	8bb2                	mv	s7,a2
  state = 0;
 4a8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4aa:	4901                	li	s2,0
 4ac:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4ae:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4b2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4b6:	06c00c93          	li	s9,108
 4ba:	a00d                	j	4dc <vprintf+0x5c>
        putc(fd, c0);
 4bc:	85a6                	mv	a1,s1
 4be:	855a                	mv	a0,s6
 4c0:	f0dff0ef          	jal	3cc <putc>
 4c4:	a019                	j	4ca <vprintf+0x4a>
    } else if(state == '%'){
 4c6:	03598363          	beq	s3,s5,4ec <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 4ca:	0019079b          	addiw	a5,s2,1
 4ce:	893e                	mv	s2,a5
 4d0:	873e                	mv	a4,a5
 4d2:	97d2                	add	a5,a5,s4
 4d4:	0007c483          	lbu	s1,0(a5)
 4d8:	20048963          	beqz	s1,6ea <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 4dc:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4e0:	fe0993e3          	bnez	s3,4c6 <vprintf+0x46>
      if(c0 == '%'){
 4e4:	fd579ce3          	bne	a5,s5,4bc <vprintf+0x3c>
        state = '%';
 4e8:	89be                	mv	s3,a5
 4ea:	b7c5                	j	4ca <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ec:	00ea06b3          	add	a3,s4,a4
 4f0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4f4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4f6:	c681                	beqz	a3,4fe <vprintf+0x7e>
 4f8:	9752                	add	a4,a4,s4
 4fa:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4fe:	03878e63          	beq	a5,s8,53a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 502:	05978863          	beq	a5,s9,552 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 506:	07500713          	li	a4,117
 50a:	0ee78263          	beq	a5,a4,5ee <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 50e:	07800713          	li	a4,120
 512:	12e78463          	beq	a5,a4,63a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 516:	07000713          	li	a4,112
 51a:	14e78963          	beq	a5,a4,66c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 51e:	07300713          	li	a4,115
 522:	18e78863          	beq	a5,a4,6b2 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 526:	02500713          	li	a4,37
 52a:	04e79463          	bne	a5,a4,572 <vprintf+0xf2>
        putc(fd, '%');
 52e:	85ba                	mv	a1,a4
 530:	855a                	mv	a0,s6
 532:	e9bff0ef          	jal	3cc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 536:	4981                	li	s3,0
 538:	bf49                	j	4ca <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 53a:	008b8493          	addi	s1,s7,8
 53e:	4685                	li	a3,1
 540:	4629                	li	a2,10
 542:	000ba583          	lw	a1,0(s7)
 546:	855a                	mv	a0,s6
 548:	ea3ff0ef          	jal	3ea <printint>
 54c:	8ba6                	mv	s7,s1
      state = 0;
 54e:	4981                	li	s3,0
 550:	bfad                	j	4ca <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 552:	06400793          	li	a5,100
 556:	02f68963          	beq	a3,a5,588 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 55a:	06c00793          	li	a5,108
 55e:	04f68263          	beq	a3,a5,5a2 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 562:	07500793          	li	a5,117
 566:	0af68063          	beq	a3,a5,606 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 56a:	07800793          	li	a5,120
 56e:	0ef68263          	beq	a3,a5,652 <vprintf+0x1d2>
        putc(fd, '%');
 572:	02500593          	li	a1,37
 576:	855a                	mv	a0,s6
 578:	e55ff0ef          	jal	3cc <putc>
        putc(fd, c0);
 57c:	85a6                	mv	a1,s1
 57e:	855a                	mv	a0,s6
 580:	e4dff0ef          	jal	3cc <putc>
      state = 0;
 584:	4981                	li	s3,0
 586:	b791                	j	4ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 588:	008b8493          	addi	s1,s7,8
 58c:	4685                	li	a3,1
 58e:	4629                	li	a2,10
 590:	000ba583          	lw	a1,0(s7)
 594:	855a                	mv	a0,s6
 596:	e55ff0ef          	jal	3ea <printint>
        i += 1;
 59a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 59c:	8ba6                	mv	s7,s1
      state = 0;
 59e:	4981                	li	s3,0
        i += 1;
 5a0:	b72d                	j	4ca <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5a2:	06400793          	li	a5,100
 5a6:	02f60763          	beq	a2,a5,5d4 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5aa:	07500793          	li	a5,117
 5ae:	06f60963          	beq	a2,a5,620 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5b2:	07800793          	li	a5,120
 5b6:	faf61ee3          	bne	a2,a5,572 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ba:	008b8493          	addi	s1,s7,8
 5be:	4681                	li	a3,0
 5c0:	4641                	li	a2,16
 5c2:	000ba583          	lw	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	e23ff0ef          	jal	3ea <printint>
        i += 2;
 5cc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ce:	8ba6                	mv	s7,s1
      state = 0;
 5d0:	4981                	li	s3,0
        i += 2;
 5d2:	bde5                	j	4ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d4:	008b8493          	addi	s1,s7,8
 5d8:	4685                	li	a3,1
 5da:	4629                	li	a2,10
 5dc:	000ba583          	lw	a1,0(s7)
 5e0:	855a                	mv	a0,s6
 5e2:	e09ff0ef          	jal	3ea <printint>
        i += 2;
 5e6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e8:	8ba6                	mv	s7,s1
      state = 0;
 5ea:	4981                	li	s3,0
        i += 2;
 5ec:	bdf9                	j	4ca <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5ee:	008b8493          	addi	s1,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4629                	li	a2,10
 5f6:	000ba583          	lw	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	defff0ef          	jal	3ea <printint>
 600:	8ba6                	mv	s7,s1
      state = 0;
 602:	4981                	li	s3,0
 604:	b5d9                	j	4ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 606:	008b8493          	addi	s1,s7,8
 60a:	4681                	li	a3,0
 60c:	4629                	li	a2,10
 60e:	000ba583          	lw	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	dd7ff0ef          	jal	3ea <printint>
        i += 1;
 618:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 61a:	8ba6                	mv	s7,s1
      state = 0;
 61c:	4981                	li	s3,0
        i += 1;
 61e:	b575                	j	4ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 620:	008b8493          	addi	s1,s7,8
 624:	4681                	li	a3,0
 626:	4629                	li	a2,10
 628:	000ba583          	lw	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	dbdff0ef          	jal	3ea <printint>
        i += 2;
 632:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 634:	8ba6                	mv	s7,s1
      state = 0;
 636:	4981                	li	s3,0
        i += 2;
 638:	bd49                	j	4ca <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 63a:	008b8493          	addi	s1,s7,8
 63e:	4681                	li	a3,0
 640:	4641                	li	a2,16
 642:	000ba583          	lw	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	da3ff0ef          	jal	3ea <printint>
 64c:	8ba6                	mv	s7,s1
      state = 0;
 64e:	4981                	li	s3,0
 650:	bdad                	j	4ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 652:	008b8493          	addi	s1,s7,8
 656:	4681                	li	a3,0
 658:	4641                	li	a2,16
 65a:	000ba583          	lw	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	d8bff0ef          	jal	3ea <printint>
        i += 1;
 664:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 666:	8ba6                	mv	s7,s1
      state = 0;
 668:	4981                	li	s3,0
        i += 1;
 66a:	b585                	j	4ca <vprintf+0x4a>
 66c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 66e:	008b8d13          	addi	s10,s7,8
 672:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 676:	03000593          	li	a1,48
 67a:	855a                	mv	a0,s6
 67c:	d51ff0ef          	jal	3cc <putc>
  putc(fd, 'x');
 680:	07800593          	li	a1,120
 684:	855a                	mv	a0,s6
 686:	d47ff0ef          	jal	3cc <putc>
 68a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68c:	00000b97          	auipc	s7,0x0
 690:	2ccb8b93          	addi	s7,s7,716 # 958 <digits>
 694:	03c9d793          	srli	a5,s3,0x3c
 698:	97de                	add	a5,a5,s7
 69a:	0007c583          	lbu	a1,0(a5)
 69e:	855a                	mv	a0,s6
 6a0:	d2dff0ef          	jal	3cc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a4:	0992                	slli	s3,s3,0x4
 6a6:	34fd                	addiw	s1,s1,-1
 6a8:	f4f5                	bnez	s1,694 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6aa:	8bea                	mv	s7,s10
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	6d02                	ld	s10,0(sp)
 6b0:	bd29                	j	4ca <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6b2:	008b8993          	addi	s3,s7,8
 6b6:	000bb483          	ld	s1,0(s7)
 6ba:	cc91                	beqz	s1,6d6 <vprintf+0x256>
        for(; *s; s++)
 6bc:	0004c583          	lbu	a1,0(s1)
 6c0:	c195                	beqz	a1,6e4 <vprintf+0x264>
          putc(fd, *s);
 6c2:	855a                	mv	a0,s6
 6c4:	d09ff0ef          	jal	3cc <putc>
        for(; *s; s++)
 6c8:	0485                	addi	s1,s1,1
 6ca:	0004c583          	lbu	a1,0(s1)
 6ce:	f9f5                	bnez	a1,6c2 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6d0:	8bce                	mv	s7,s3
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bbdd                	j	4ca <vprintf+0x4a>
          s = "(null)";
 6d6:	00000497          	auipc	s1,0x0
 6da:	27a48493          	addi	s1,s1,634 # 950 <malloc+0x16a>
        for(; *s; s++)
 6de:	02800593          	li	a1,40
 6e2:	b7c5                	j	6c2 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 6e4:	8bce                	mv	s7,s3
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	b3cd                	j	4ca <vprintf+0x4a>
 6ea:	6906                	ld	s2,64(sp)
 6ec:	79e2                	ld	s3,56(sp)
 6ee:	7a42                	ld	s4,48(sp)
 6f0:	7aa2                	ld	s5,40(sp)
 6f2:	7b02                	ld	s6,32(sp)
 6f4:	6be2                	ld	s7,24(sp)
 6f6:	6c42                	ld	s8,16(sp)
 6f8:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6fa:	60e6                	ld	ra,88(sp)
 6fc:	6446                	ld	s0,80(sp)
 6fe:	64a6                	ld	s1,72(sp)
 700:	6125                	addi	sp,sp,96
 702:	8082                	ret

0000000000000704 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 704:	715d                	addi	sp,sp,-80
 706:	ec06                	sd	ra,24(sp)
 708:	e822                	sd	s0,16(sp)
 70a:	1000                	addi	s0,sp,32
 70c:	e010                	sd	a2,0(s0)
 70e:	e414                	sd	a3,8(s0)
 710:	e818                	sd	a4,16(s0)
 712:	ec1c                	sd	a5,24(s0)
 714:	03043023          	sd	a6,32(s0)
 718:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 71c:	8622                	mv	a2,s0
 71e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 722:	d5fff0ef          	jal	480 <vprintf>
}
 726:	60e2                	ld	ra,24(sp)
 728:	6442                	ld	s0,16(sp)
 72a:	6161                	addi	sp,sp,80
 72c:	8082                	ret

000000000000072e <printf>:

void
printf(const char *fmt, ...)
{
 72e:	711d                	addi	sp,sp,-96
 730:	ec06                	sd	ra,24(sp)
 732:	e822                	sd	s0,16(sp)
 734:	1000                	addi	s0,sp,32
 736:	e40c                	sd	a1,8(s0)
 738:	e810                	sd	a2,16(s0)
 73a:	ec14                	sd	a3,24(s0)
 73c:	f018                	sd	a4,32(s0)
 73e:	f41c                	sd	a5,40(s0)
 740:	03043823          	sd	a6,48(s0)
 744:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 748:	00840613          	addi	a2,s0,8
 74c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 750:	85aa                	mv	a1,a0
 752:	4505                	li	a0,1
 754:	d2dff0ef          	jal	480 <vprintf>
}
 758:	60e2                	ld	ra,24(sp)
 75a:	6442                	ld	s0,16(sp)
 75c:	6125                	addi	sp,sp,96
 75e:	8082                	ret

0000000000000760 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 760:	1141                	addi	sp,sp,-16
 762:	e406                	sd	ra,8(sp)
 764:	e022                	sd	s0,0(sp)
 766:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 768:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76c:	00001797          	auipc	a5,0x1
 770:	8947b783          	ld	a5,-1900(a5) # 1000 <freep>
 774:	a02d                	j	79e <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 776:	4618                	lw	a4,8(a2)
 778:	9f2d                	addw	a4,a4,a1
 77a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 77e:	6398                	ld	a4,0(a5)
 780:	6310                	ld	a2,0(a4)
 782:	a83d                	j	7c0 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 784:	ff852703          	lw	a4,-8(a0)
 788:	9f31                	addw	a4,a4,a2
 78a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 78c:	ff053683          	ld	a3,-16(a0)
 790:	a091                	j	7d4 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 792:	6398                	ld	a4,0(a5)
 794:	00e7e463          	bltu	a5,a4,79c <free+0x3c>
 798:	00e6ea63          	bltu	a3,a4,7ac <free+0x4c>
{
 79c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79e:	fed7fae3          	bgeu	a5,a3,792 <free+0x32>
 7a2:	6398                	ld	a4,0(a5)
 7a4:	00e6e463          	bltu	a3,a4,7ac <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a8:	fee7eae3          	bltu	a5,a4,79c <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 7ac:	ff852583          	lw	a1,-8(a0)
 7b0:	6390                	ld	a2,0(a5)
 7b2:	02059813          	slli	a6,a1,0x20
 7b6:	01c85713          	srli	a4,a6,0x1c
 7ba:	9736                	add	a4,a4,a3
 7bc:	fae60de3          	beq	a2,a4,776 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7c0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7c4:	4790                	lw	a2,8(a5)
 7c6:	02061593          	slli	a1,a2,0x20
 7ca:	01c5d713          	srli	a4,a1,0x1c
 7ce:	973e                	add	a4,a4,a5
 7d0:	fae68ae3          	beq	a3,a4,784 <free+0x24>
    p->s.ptr = bp->s.ptr;
 7d4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7d6:	00001717          	auipc	a4,0x1
 7da:	82f73523          	sd	a5,-2006(a4) # 1000 <freep>
}
 7de:	60a2                	ld	ra,8(sp)
 7e0:	6402                	ld	s0,0(sp)
 7e2:	0141                	addi	sp,sp,16
 7e4:	8082                	ret

00000000000007e6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e6:	7139                	addi	sp,sp,-64
 7e8:	fc06                	sd	ra,56(sp)
 7ea:	f822                	sd	s0,48(sp)
 7ec:	f04a                	sd	s2,32(sp)
 7ee:	ec4e                	sd	s3,24(sp)
 7f0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f2:	02051993          	slli	s3,a0,0x20
 7f6:	0209d993          	srli	s3,s3,0x20
 7fa:	09bd                	addi	s3,s3,15
 7fc:	0049d993          	srli	s3,s3,0x4
 800:	2985                	addiw	s3,s3,1
 802:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 804:	00000517          	auipc	a0,0x0
 808:	7fc53503          	ld	a0,2044(a0) # 1000 <freep>
 80c:	c905                	beqz	a0,83c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 810:	4798                	lw	a4,8(a5)
 812:	09377663          	bgeu	a4,s3,89e <malloc+0xb8>
 816:	f426                	sd	s1,40(sp)
 818:	e852                	sd	s4,16(sp)
 81a:	e456                	sd	s5,8(sp)
 81c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 81e:	8a4e                	mv	s4,s3
 820:	6705                	lui	a4,0x1
 822:	00e9f363          	bgeu	s3,a4,828 <malloc+0x42>
 826:	6a05                	lui	s4,0x1
 828:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 82c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 830:	00000497          	auipc	s1,0x0
 834:	7d048493          	addi	s1,s1,2000 # 1000 <freep>
  if(p == (char*)-1)
 838:	5afd                	li	s5,-1
 83a:	a83d                	j	878 <malloc+0x92>
 83c:	f426                	sd	s1,40(sp)
 83e:	e852                	sd	s4,16(sp)
 840:	e456                	sd	s5,8(sp)
 842:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 844:	00000797          	auipc	a5,0x0
 848:	7cc78793          	addi	a5,a5,1996 # 1010 <base>
 84c:	00000717          	auipc	a4,0x0
 850:	7af73a23          	sd	a5,1972(a4) # 1000 <freep>
 854:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 856:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 85a:	b7d1                	j	81e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 85c:	6398                	ld	a4,0(a5)
 85e:	e118                	sd	a4,0(a0)
 860:	a899                	j	8b6 <malloc+0xd0>
  hp->s.size = nu;
 862:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 866:	0541                	addi	a0,a0,16
 868:	ef9ff0ef          	jal	760 <free>
  return freep;
 86c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 86e:	c125                	beqz	a0,8ce <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 870:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 872:	4798                	lw	a4,8(a5)
 874:	03277163          	bgeu	a4,s2,896 <malloc+0xb0>
    if(p == freep)
 878:	6098                	ld	a4,0(s1)
 87a:	853e                	mv	a0,a5
 87c:	fef71ae3          	bne	a4,a5,870 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 880:	8552                	mv	a0,s4
 882:	b33ff0ef          	jal	3b4 <sbrk>
  if(p == (char*)-1)
 886:	fd551ee3          	bne	a0,s5,862 <malloc+0x7c>
        return 0;
 88a:	4501                	li	a0,0
 88c:	74a2                	ld	s1,40(sp)
 88e:	6a42                	ld	s4,16(sp)
 890:	6aa2                	ld	s5,8(sp)
 892:	6b02                	ld	s6,0(sp)
 894:	a03d                	j	8c2 <malloc+0xdc>
 896:	74a2                	ld	s1,40(sp)
 898:	6a42                	ld	s4,16(sp)
 89a:	6aa2                	ld	s5,8(sp)
 89c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 89e:	fae90fe3          	beq	s2,a4,85c <malloc+0x76>
        p->s.size -= nunits;
 8a2:	4137073b          	subw	a4,a4,s3
 8a6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a8:	02071693          	slli	a3,a4,0x20
 8ac:	01c6d713          	srli	a4,a3,0x1c
 8b0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b6:	00000717          	auipc	a4,0x0
 8ba:	74a73523          	sd	a0,1866(a4) # 1000 <freep>
      return (void*)(p + 1);
 8be:	01078513          	addi	a0,a5,16
  }
}
 8c2:	70e2                	ld	ra,56(sp)
 8c4:	7442                	ld	s0,48(sp)
 8c6:	7902                	ld	s2,32(sp)
 8c8:	69e2                	ld	s3,24(sp)
 8ca:	6121                	addi	sp,sp,64
 8cc:	8082                	ret
 8ce:	74a2                	ld	s1,40(sp)
 8d0:	6a42                	ld	s4,16(sp)
 8d2:	6aa2                	ld	s5,8(sp)
 8d4:	6b02                	ld	s6,0(sp)
 8d6:	b7f5                	j	8c2 <malloc+0xdc>
