-- CreateTable
CREATE TABLE `users` (
    `id` VARCHAR(36) NOT NULL,
    `studentId` VARCHAR(20) NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `sejongPid` VARCHAR(50) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `users_studentId_key`(`studentId`),
    INDEX `users_studentId_idx`(`studentId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `meetings` (
    `id` VARCHAR(36) NOT NULL,
    `inviteCode` VARCHAR(20) NOT NULL,
    `title` VARCHAR(100) NOT NULL,
    `description` VARCHAR(500) NULL,
    `initUserId` VARCHAR(36) NOT NULL,
    `deadlineAt` DATETIME(3) NOT NULL,
    `status` ENUM('PENDING', 'COMPLETED', 'FAILED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `meetings_inviteCode_key`(`inviteCode`),
    INDEX `meetings_initUserId_idx`(`initUserId`),
    INDEX `meetings_status_idx`(`status`),
    INDEX `meetings_deadlineAt_idx`(`deadlineAt`),
    INDEX `meetings_inviteCode_idx`(`inviteCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `meeting_dates` (
    `id` VARCHAR(36) NOT NULL,
    `meetingId` VARCHAR(36) NOT NULL,
    `date` DATE NOT NULL,

    INDEX `meeting_dates_meetingId_idx`(`meetingId`),
    UNIQUE INDEX `meeting_dates_meetingId_date_key`(`meetingId`, `date`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `participants` (
    `id` VARCHAR(36) NOT NULL,
    `meetingId` VARCHAR(36) NOT NULL,
    `userId` VARCHAR(36) NULL,
    `studentId` VARCHAR(20) NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `sejongPid` VARCHAR(50) NULL,
    `isLoggedIn` BOOLEAN NOT NULL DEFAULT false,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `participants_meetingId_idx`(`meetingId`),
    INDEX `participants_userId_idx`(`userId`),
    UNIQUE INDEX `participants_meetingId_studentId_key`(`meetingId`, `studentId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `time_selections` (
    `id` VARCHAR(36) NOT NULL,
    `participantId` VARCHAR(36) NOT NULL,
    `meetingDateId` VARCHAR(36) NOT NULL,
    `hour` TINYINT NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `time_selections_participantId_idx`(`participantId`),
    INDEX `time_selections_meetingDateId_idx`(`meetingDateId`),
    UNIQUE INDEX `time_selections_participantId_meetingDateId_hour_key`(`participantId`, `meetingDateId`, `hour`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `studyrooms` (
    `id` INTEGER NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `location` VARCHAR(200) NOT NULL,
    `minUsers` TINYINT NOT NULL,
    `maxUsers` TINYINT NOT NULL,
    `operatingStart` TINYINT NOT NULL DEFAULT 10,
    `operatingEnd` TINYINT NOT NULL DEFAULT 22,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `reservations` (
    `id` VARCHAR(36) NOT NULL,
    `meetingId` VARCHAR(36) NOT NULL,
    `studyroomId` INTEGER NOT NULL,
    `date` DATE NOT NULL,
    `startHour` TINYINT NOT NULL,
    `duration` TINYINT NOT NULL,
    `sejongBookingId` VARCHAR(50) NULL,
    `status` ENUM('PENDING', 'SUCCESS', 'FAILED') NOT NULL DEFAULT 'PENDING',
    `failReason` VARCHAR(500) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `reservations_meetingId_key`(`meetingId`),
    INDEX `reservations_status_idx`(`status`),
    INDEX `reservations_date_idx`(`date`),
    INDEX `reservations_meetingId_idx`(`meetingId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `reservation_users` (
    `id` VARCHAR(36) NOT NULL,
    `reservationId` VARCHAR(36) NOT NULL,
    `participantId` VARCHAR(36) NOT NULL,
    `isLeader` BOOLEAN NOT NULL DEFAULT false,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `reservation_users_reservationId_idx`(`reservationId`),
    INDEX `reservation_users_participantId_idx`(`participantId`),
    UNIQUE INDEX `reservation_users_reservationId_participantId_key`(`reservationId`, `participantId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `meetings` ADD CONSTRAINT `meetings_initUserId_fkey` FOREIGN KEY (`initUserId`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `meeting_dates` ADD CONSTRAINT `meeting_dates_meetingId_fkey` FOREIGN KEY (`meetingId`) REFERENCES `meetings`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `participants` ADD CONSTRAINT `participants_meetingId_fkey` FOREIGN KEY (`meetingId`) REFERENCES `meetings`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `participants` ADD CONSTRAINT `participants_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `time_selections` ADD CONSTRAINT `time_selections_participantId_fkey` FOREIGN KEY (`participantId`) REFERENCES `participants`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `time_selections` ADD CONSTRAINT `time_selections_meetingDateId_fkey` FOREIGN KEY (`meetingDateId`) REFERENCES `meeting_dates`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `reservations` ADD CONSTRAINT `reservations_meetingId_fkey` FOREIGN KEY (`meetingId`) REFERENCES `meetings`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `reservations` ADD CONSTRAINT `reservations_studyroomId_fkey` FOREIGN KEY (`studyroomId`) REFERENCES `studyrooms`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `reservation_users` ADD CONSTRAINT `reservation_users_reservationId_fkey` FOREIGN KEY (`reservationId`) REFERENCES `reservations`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `reservation_users` ADD CONSTRAINT `reservation_users_participantId_fkey` FOREIGN KEY (`participantId`) REFERENCES `participants`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
