! (C) Copyright 2022- ECMWF.
! (C) Copyright 2022- Meteo-France.
!
! This software is licensed under the terms of the Apache Licence Version 2.0
! which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
! In applying this licence, ECMWF does not waive the privileges and immunities
! granted to it by virtue of its status as an intergovernmental organisation
! nor does it submit to any jurisdiction.

PROGRAM INIT_OWNER_INIT_DEBUG_VALUE_GPU
        !TEST THAT ALL DATA ARE INITIALIZED TO THE DEBUG VALUE CHOOSED BY THE
        !USER ON GPU
        USE FIELD_MODULE
        USE FIELD_FACTORY_MODULE
        USE FIELD_DEFAULTS_MODULE
        USE PARKIND1
        USE FIELD_ABORT_MODULE
        IMPLICIT NONE
        CLASS(FIELD_2IM), POINTER :: OIM => NULL()
        !CLASS(FIELD_2RM), POINTER :: ORM => NULL()
        !CLASS(FIELD_2RD), POINTER :: ORD => NULL()
        !CLASS(FIELD_2RB), POINTER :: ORB => NULL()
        INTEGER(KIND=JPIM), POINTER :: PTRIM(:,:)
        !REAL(KIND=JPRM), POINTER :: PTRRM(:,:)
        !REAL(KIND=JPRD), POINTER :: PTRRD(:,:)
        !REAL(KIND=JPRB), POINTER :: PTRRB(:,:)
        LOGICAL :: OKAY
        INTEGER :: I,J

        USE_INIT_DEBUG_VALUE = .TRUE.
        INIT_DEBUG_VALUE_JPIM=-123456789

        CALL FIELD_NEW(OIM, LBOUNDS=[1,1], UBOUNDS=[10,10])
        CALL OIM%GET_DEVICE_DATA_RDONLY(PTRIM)

        OKAY=.TRUE.
#ifdef OMPGPU
        !$OMP TARGET MAP(TO:PTRIM) MAP(TOFROM:OKAY)
#else
        !$ACC SERIAL PRESENT(PTRIM) COPY(OKAY)
#endif
        DO J=1,UBOUND(PTRIM,2)
          DO I=1,10
            IF (PTRIM(I,J) /= -123456789) THEN
              OKAY = .FALSE.
            ENDIF
          ENDDO
        ENDDO
#ifdef OMPGPU
        !$OMP END TARGET
#else
        !$ACC END SERIAL
#endif

        IF(OKAY .EQV. .FALSE.)THEN
                CALL FIELD_ABORT ("ERROR")
        ENDIF

        CALL FIELD_DELETE(OIM)
END PROGRAM INIT_OWNER_INIT_DEBUG_VALUE_GPU
